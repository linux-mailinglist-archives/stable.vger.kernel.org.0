Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4686CA608
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjC0NgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 09:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjC0NgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 09:36:03 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C978344B0
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 06:36:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c4so5722230pfl.0
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679924161; x=1682516161;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qk8mEmXhmkij8TFHjllJ20n3reyRkxB51/J3Ax/p7n0=;
        b=2Gk3ezhjrVnvJZJD1N/OMSWUjmgh1iwcVRjCz3DVGcgZG92GdNw+CFM9I06aJL1Rbf
         9NqFfADa9ykfd5bBOwhSyG0ym1BtUuN/beUzlVFRsLBOSJtawH2gL3PyCrmIF1Z/kzt4
         JFDp6r4h0ugpkkN6cwOPAx41YYDfcJ35zyGj7VjIblrpEsNh3c536YpA5SEerN46g4JA
         /WswQ/cu0wfCyUv1eUNyjHrYQ0E0DSbfZDeQQwJ+nsbSjpbt+O8mGUgB/GaA13QRTXqr
         dTq5nUwrR/dOIIftlofcdDGRnR8Oy+6pSozGNuNx/5/OGTSeu64G9eE1Vym6qk52a8Td
         oUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679924161; x=1682516161;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qk8mEmXhmkij8TFHjllJ20n3reyRkxB51/J3Ax/p7n0=;
        b=ePuHVFcsOmuPA7Op4CHChCbppXEQm5spEuWy4t8TiXNj9XLIK4/63eUy6GDioVpEkQ
         //7pV6kapja5lFPL5+3f5KgAj/dUDLlXZwVkuK6G3MgPiUSOgttTjoOQTGOzPi4VUU7J
         9HG38AawG0SkaM14TUBzSmPy5TLi/y1lkGlASaEudXsd700kdHobq48BU2/sjMFlnzig
         AEHEAmVfxhWz830U51iiyxv30oX3aTIoxr1dAYLFDVNvZc1xnbygP8JX/Zui0oqd8jHu
         Psx/w4PoY7mJcTslpBH1RI66v4y7lfEk5antcv+mAqRi9Zg840I+qcy217dwVvs5Sils
         U0fw==
X-Gm-Message-State: AAQBX9eLUgzCNQCvX3m+GtCHfQU2vyMG3U1BJgU6OIPkko3NvSCdATv7
        NgInkNdGCc/dALoDIVWnjNCKzv8Gw97bqTPRRzNF+g==
X-Google-Smtp-Source: AKy350Zz+gdHQ/wN2j/B1WoIVJSpBA6wWKADWT0oO0RAhFL6sv6RQnVfETBicFxwyjWuAV1b5VeS/A==
X-Received: by 2002:aa7:8b1a:0:b0:628:630:a374 with SMTP id f26-20020aa78b1a000000b006280630a374mr10585278pfd.2.1679924160975;
        Mon, 27 Mar 2023 06:36:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p26-20020aa7861a000000b006249928aba2sm19038827pfn.59.2023.03.27.06.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 06:36:00 -0700 (PDT)
Message-ID: <d6818b66-e1c8-e2bf-e54f-73d1f83db020@kernel.dk>
Date:   Mon, 27 Mar 2023 07:35:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Syzkaller & bisect] There is "io_poll_remove_entries" NULL
 pointer BUG in v6.3-rc4 kernel
Content-Language: en-US
To:     Pengfei Xu <pengfei.xu@intel.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        heng.su@intel.com, lkp@intel.com
References: <ZCEy5jA2nT/vaO56@xpf.sh.intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZCEy5jA2nT/vaO56@xpf.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/27/23 12:08?AM, Pengfei Xu wrote:
> Hi Jens Axboe and kernel experts,
> 
> Platform: x86 platforms
> There is "io_poll_remove_entries" NULL pointer BUG in v6.3-rc4 kernel.
> 
> All detailed log: https://github.com/xupengfe/syzkaller_logs/tree/main/230327_041425_io_poll_remove_entries
> Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.c
> Syzkaller analysis report0: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/report0
> Syzkaller analysis status: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.stats
> v6.3-rc4 issue dmesg: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/v63rc4_reproduce_dmesg.log
> Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/kconfig_origin
> Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/bisect_info.log
> 
> It could be reproduced in v6.3-rc3 and v6.3-rc4 kernel, and bisected between
> v6.3-rc3 and v5.11 kernel, bad commit was:
> "
> c16bda37594f83147b167d381d54c010024efecf
> io_uring/poll: allow some retries for poll triggering spuriously
> "
> After reverted above commit on top of v6.3-rc3 kernel, this issue was gone.

This should probably fix it, though I do wonder why this can only
trigger after that patch. Seems like it would've been possible before
too.


diff --git a/io_uring/poll.c b/io_uring/poll.c
index 795facbd0e9f..90555a22a900 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -600,7 +600,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	if (unlikely(ipt->error || !ipt->nr_entries)) {
-		io_poll_remove_entries(req);
+		if (ipt->nr_entries)
+			io_poll_remove_entries(req);
 
 		if (!io_poll_can_finish_inline(req, ipt)) {
 			io_poll_mark_cancelled(req);

-- 
Jens Axboe

