Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90771D8B53
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 01:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgERXBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 19:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgERXBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 19:01:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B8C061A0C;
        Mon, 18 May 2020 16:01:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id c75so4511142pga.3;
        Mon, 18 May 2020 16:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n/2OdOyoZ864HE1NL5cRmRErjnYTeC8BJcUUPBVh8xM=;
        b=A+9BSmUUtr7xOkMfzrYupN58DMh1l96MQ613yRIEfsWKPqD1QJfdrtHrKaRavl4Zrr
         +Q0xZEhP4en3JvaFqxqsP0LawRxX5xfdQiwkfUebitrU8BwZk2zluMK2JvXbET7SNkeb
         OL94AHQq1J12qDvV1UZD4fPNog6B/SyHdmHdJO/wOcsmxWCQEzBChgrWNOucDZynuGq2
         FkwxBesagZnWfwsQ5eb+S2EJFE5ASRMNah32uFQ1Ffs1xPDedB5/n0x4O/Hl8m9ttRzM
         sw5YtZKStt+nGP4UWBD6gNxs0AiI/qJvNv9IFo10aVWNSyEnHCoTxmjbjpMLTwWuhMlm
         1o/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=n/2OdOyoZ864HE1NL5cRmRErjnYTeC8BJcUUPBVh8xM=;
        b=NRk2u07dgaPIRXiKE5wyBCoNuI9kYpkyMJz6I+TCxvK8qlE+bueMX8hmVue2TSwoXJ
         9O0DhxxyJO06/0qUAIIOHG6PxeJztz+8PByCdE+C0oFaDGSCBouEPujXdGfkSfauj4oU
         CH9NjcKt6FUWU18vTcibuZkVk/o2mMfszmzcyPJggzgn5XExYr7/ShQsp0jWEXLm+yGG
         popiyWacgB3PkZJ33HrU1/3e79TBktsgyFwOlpSLpwzXsAv96coTjONkJTn+2evBvmQb
         Z4uGWI3GP2xxsZQmwZhGsu302b4gJtL9lJC5G86maFQTtZpoMdwE8Jf06j6uOFqGV3Cl
         sRpQ==
X-Gm-Message-State: AOAM530X54S7QQDVeuarY+CsgWi7td6IxtPM8g0eIZlQMr66xa4pzKAY
        JXherPbNd/W6PiIcp4sH/58=
X-Google-Smtp-Source: ABdhPJx7GzJtBjw0rqbTS8tx+JTXheQvDQG/wzKR5PbOQzB2X/jRHeKRAJEZwrDiaHNKIu2UGq/xuQ==
X-Received: by 2002:a05:6a00:1494:: with SMTP id v20mr13966289pfu.150.1589842894625;
        Mon, 18 May 2020 16:01:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w199sm3811206pfc.68.2020.05.18.16.01.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 May 2020 16:01:33 -0700 (PDT)
Date:   Mon, 18 May 2020 16:01:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/194] 5.6.14-rc1 review
Message-ID: <20200518230132.GA176285@roeck-us.net>
References: <20200518173531.455604187@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 07:34:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.14 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 

Quick feedback:

You also need to pull in commit 92db978f0d68 ("net: ethernet: ti: Remove
TI_CPTS_MOD workaround") which fixes commit b6d49cab44b5 ("net: Make
PTP-specific drivers depend on PTP_1588_CLOCK"). This is necessary to
avoid various compile errors (see below).

Guenter

---
Building arm:omap2plus_defconfig ... failed
--------------
Error log:
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
drivers/net/ethernet/ti/cpsw.c:886: undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_remove':
drivers/net/ethernet/ti/cpsw.c:1741: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_rx_handler':
drivers/net/ethernet/ti/cpsw.c:437: undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw.c:840: undefined reference to `cpts_register'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_probe':
drivers/net/ethernet/ti/cpsw.c:1716: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0x34): undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0x194): undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0x350): undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0xb20): undefined reference to `cpts_register'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o: in function `cpsw_tx_handler':
drivers/net/ethernet/ti/cpsw_priv.c:68: undefined reference to `cpts_tx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o: in function `cpsw_init_common':
drivers/net/ethernet/ti/cpsw_priv.c:525: undefined reference to `cpts_create'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o:(.debug_addr+0xa38): undefined reference to `cpts_tx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o:(.debug_addr+0xc90): undefined reference to `cpts_create'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_ndo_stop':
drivers/net/ethernet/ti/cpsw_new.c:814: undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_remove':
drivers/net/ethernet/ti/cpsw_new.c:2028: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_rx_handler':
drivers/net/ethernet/ti/cpsw_new.c:379: undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_probe':
drivers/net/ethernet/ti/cpsw_new.c:2004: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw_new.c:874: undefined reference to `cpts_register'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0x38): undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0x158): undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0x2c4): undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0xa60): undefined reference to `cpts_register'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2
--------------

Building arm:keystone_defconfig ... failed
--------------
Error log:
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_rxtstamp':
drivers/net/ethernet/ti/netcp_ethss.c:2595: undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_probe':
drivers/net/ethernet/ti/netcp_ethss.c:3719: undefined reference to `cpts_create'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_remove':
drivers/net/ethernet/ti/netcp_ethss.c:3812: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_unregister_cpts':
drivers/net/ethernet/ti/netcp_ethss.c:2731: undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_register_cpts':
drivers/net/ethernet/ti/netcp_ethss.c:2714: undefined reference to `cpts_register'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2
