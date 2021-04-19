Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6D364433
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhDSNZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241948AbhDSNY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 09:24:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478C5C06135F;
        Mon, 19 Apr 2021 06:22:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so524718edb.2;
        Mon, 19 Apr 2021 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W7CsnyaPr2uiGZSp3NOvUiv0ehuakf8xgMXAMA6jznE=;
        b=J1ChcLJk88nXKgpPHKXkZQPIQQBmGj0sRlSRCfFMymnRomKYAy8HrwrrYdKNmdEK0J
         QiU0MI0K2tfvw+9MqtfA/8j13vz7wXZITyD8TgCpaIvlIe92HRlJTm+qJI2e26/7W0MZ
         q4eNdPOXN/3M5INlQT0MEQM0QQgiyXiLrMYRax322f5JbYJjWM0Jz7nOsdwEjEDWNaA5
         tnpYEI75m3u5WbboIh1PgoK0oOSCkRGrhYmnwW8rnSGIz2mUsPSfVuulf81mgChzRBjA
         f7krqwwUc/ZjhyH1uq/3If4eOiBigG3o/LxdqGqEY6PMrwghS0jKSvHg3f85hqN4cv1r
         1UjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=W7CsnyaPr2uiGZSp3NOvUiv0ehuakf8xgMXAMA6jznE=;
        b=gjY8OMtnXGFsQbggNdXWHsLHnPlVKCO37ExqsEw13M89a37F2VuZnnLPL91FqTuw1X
         3jlJ4tmQNm2eFJTe9csu2qgx5yY9egrN87Y5JZ+Sj3YDQ0yg3MQ2ng21pEr2f2XVicFh
         F5yPqL2SPvWYafTHebIjg/bItxvYoA/nmqBn8OOoAWVX8yqZ0VjRw+q0vLQMN+3N2z2a
         02Q26fLewXBjtLXhO1iHZxWdI4LDaRFTgjHcvc/45S7RBOHokS9ygz7/mhF9FvWeH07n
         +YUjebjJUjqEqhEp+xVyraU05RAQVlM7vmm662BcNVmWPL83yBfbFfRdzmSniuo37tdD
         8hUw==
X-Gm-Message-State: AOAM530cIgXJWkvMCiB1VPsCdvZU3wjEZyZscmITPdGHBtWeaHCzeQrT
        c588qsJfTvwrrmdileojeRc=
X-Google-Smtp-Source: ABdhPJwg9gkfqm2dZZ+4qT8V1xF/yCpcDKZdsNVCP0f972IMf3aaIJ5hjIrDS/aPC87O6IxNckh+xg==
X-Received: by 2002:a05:6402:1393:: with SMTP id b19mr25344097edv.333.1618838538114;
        Mon, 19 Apr 2021 06:22:18 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id f19sm10757591ejc.54.2021.04.19.06.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 06:22:16 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Mon, 19 Apr 2021 15:22:15 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YH2EBzOKkg4kGoQn@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com>
 <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shyam,

On Mon, Apr 19, 2021 at 05:48:24AM +0000, Shyam Prasad wrote:
> <Including Paulo in this email thread>
> 
> Hi Salvatore,
> 
> Attached is a proposed fix from Paulo for older kernels. 
> Can you please confirm that this works for you too? 

So just to be clear, first apply again a738c93fb1c1 and then your
additional patch on top?

Regards,
Salvatore
