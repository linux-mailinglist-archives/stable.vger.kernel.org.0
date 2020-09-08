Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21835261D77
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgIHThd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730969AbgIHP4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:56:53 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF14C061236
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 06:29:12 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g128so16974572iof.11
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 06:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=A1r60v8ZgyDSgX2K4LR7imH9u1h6HGvpOSRJqhBPC74=;
        b=oUxP9NEpUL51urWS58g7Pn+xRV/B2rOph+yVvwBGSGvBl5vo3gYirSrHlYbAzoIlKq
         4aLY9qzDrUrobD06C77IQ8rWfD+QRnsQoPVBq1yBRyWf/rR0Q3UGfPxG9rVY3GqojOa+
         J7Kmc+XA8g3OGn7RyEYJopQj6q11TwYLJjtn3Xoz1o+XeZeIA7SiphKbFvv12k2vZ3Yl
         x2Fnhy1zlJuSfrAV1/EvS7q0ogG1y3xlGpLwPLNIyD/t0XoJPqghOXvoqHXcoK9EjF+7
         C1RGiSbO7qZAOw02Tu5LKeG7+GSMfXCv/smTbtBt6pW0h94/CTg/A90++dt5NBGWaGNE
         d+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=A1r60v8ZgyDSgX2K4LR7imH9u1h6HGvpOSRJqhBPC74=;
        b=eofh5dx8z9jwKi+Y5wG+l34kKWUZrOyn9KrdNogae9e5BdOjsZgcIg7M93EnwcezBB
         jJKddUeusaJLCRW9qW5QcZ+7qy2e16PTWiE7aPlfyLL0s0ps7/1GVFjypWfqs6G2XcIF
         tB+rk6pTK6G1apPtUOu+GzzaFQLoFPKG9Y5Sc+ku2+fWuw+OoVInvwYrZ6vV0WI98aM1
         CVBeYvp68SiMZIg45KbEzbu1zdvBi3pjGGYRAVFgeN5PHc4y5/B3Gve4WxEeKmBoi5Aw
         KS6cBVvBIW7Mc491KzdJfiWolHfRjcJFnzw88At0HJv9n6kLOYaBIG57VFq/B1rwhJM6
         NoFA==
X-Gm-Message-State: AOAM533EOwm2TAZxGCY1ZZumrHW+yS3mRW3X36JPxmHE7Jvtc8mCpVr/
        hPFqy1q2JzU0gehAC0ImIDwMVk0yNd1CEkBU
X-Google-Smtp-Source: ABdhPJwYOJR8jAbKm1zEVFA9giX945IopZa/ERGQr7s4FrD2OoZ0vmZZvektdSoCQ30wqtsdCKRBGg==
X-Received: by 2002:a05:6602:154e:: with SMTP id h14mr9862417iow.17.1599571751689;
        Tue, 08 Sep 2020 06:29:11 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r5sm4005892ilc.2.2020.09.08.06.29.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 06:29:11 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.8 stable inclusion request
Message-ID: <fc20c685-8cd1-37f3-8c8f-9ce70b0911c1@kernel.dk>
Date:   Tue, 8 Sep 2020 07:29:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can I get these two queued up, in this order:

commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Sep 6 00:45:14 2020 +0300

    io_uring: fix cancel of deferred reqs with ->files

and

commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef (tag: io_uring-5.9-2020-09-06, origin/i
o_uring-5.9, io_uring-5.9)
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Sep 6 00:45:15 2020 +0300

    io_uring: fix linked deferred ->files cancellation

which should both cherry-pick cleanly into the 5.8-stable tree.

Thanks!

-- 
Jens Axboe

