Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369F641332F
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 14:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhIUMLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 08:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhIUMLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 08:11:41 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDDC061574;
        Tue, 21 Sep 2021 05:10:13 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id p22-20020a4a8156000000b002a8c9ea1858so3022868oog.11;
        Tue, 21 Sep 2021 05:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MEitvRVPU1bZM6h4DsVIY7p9w6caI33YZWWlCX1JKLc=;
        b=GeIXuRYm9E2BnYANtpmouErPfnKwK/Mf6bpKYQT6cbBfvuFrZ5Ncfbxkd34kLPRxHB
         +tte1mlOBTIA4cAKLf2xwH+Tyhj2R1gZcqy2Z1piAVxwyyReA+47ZuTnFOVW75BwBPQE
         XKvEllyFQeN4GZgeH1EHPGamGomptV2lwLCkpwA3pqrqPMStW8ApeSX1QzzzIzrbUyKt
         lhOVsnFpgbBQbFk+s2q/UbuxiOZNrxqZVMpCkvkxwLXrqgtNQYxSB+MQOtNtCutecy4o
         L/LkTurHv741xJFstVkknJNAZ6j52DtwS2p9vHarnakw8ECpSGXatfe7TGXAGLzSQwRp
         WkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=MEitvRVPU1bZM6h4DsVIY7p9w6caI33YZWWlCX1JKLc=;
        b=rgz6BL3rXkV523e7f8rLPxSvwSCEe/HW7hLg8hQGTbYuY/p9qzZdM1VrFBl6Nqwhje
         sj+JQSvn3i++rxtq6bKtDcprAnUkw0I6dAczrQPKvxJOdcDBWuSCIX6JArunUV6R7yjU
         LB/fo+2BIjNN0CC+k3XW54XYgf3m51b+0U2Qmr/bjRwzZQyp6/YwS2cfWXPWilYlx0DT
         mqcI/nnnOqdkOIZQFczRBzLVA9cRRRSrxssg/PBrKvEcsb0lTAxaRAJvO+2l81spREAq
         NsNblncgKLc177m5BI/A0b68srPR3qKjqwn8IThaeJ9at5D8jOXzBWsPVrOUW5LlVvDG
         PAWA==
X-Gm-Message-State: AOAM533l5nOQk66l45UolpKu19Lk7I+Uzl1W3b5MDFbCpGhtDkYes5SE
        WYpmIoLadUmR5l0qsc7e0KGF/SeM2MI=
X-Google-Smtp-Source: ABdhPJyKy1z0uojVOrA02p5RI/94UhBTCdGJ12XEdZBVBvPIP8lTjSA01n2lJJhSgx+c7qs6JuzNmA==
X-Received: by 2002:a4a:6442:: with SMTP id d2mr12699794oof.37.1632226212647;
        Tue, 21 Sep 2021 05:10:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23sm4124399otp.44.2021.09.21.05.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 05:10:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 05:10:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/175] 4.9.283-rc1 review
Message-ID: <20210921121010.GA1043608@roeck-us.net>
References: <20210920163918.068823680@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:40:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.283 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

drivers/net/ethernet/ibm/ibmvnic.c: In function ‘handle_login_rsp’:
drivers/net/ethernet/ibm/ibmvnic.c:2530:15: error: ‘struct ibmvnic_adapter’ has no member named ‘failover_pending’; did you mean ‘failover’?
  if (adapter->failover_pending) {
               ^~~~~~~~~~~~~~~~
               failover
drivers/net/ethernet/ibm/ibmvnic.c:2531:12: error: ‘struct ibmvnic_adapter’ has no member named ‘init_done_rc’

drivers/net/ethernet/ibm/ibmvnic.c:2532:14: error: ‘netdev’ undeclared (first use in this function); did you mean ‘net_eq’?
   netdev_dbg(netdev, "Failover pending, ignoring login response\n");
              ^
include/linux/dynamic_debug.h:142:37: note: in definition of macro ‘dynamic_netdev_dbg’

Guenter
