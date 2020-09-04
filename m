Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF07F25E32B
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 23:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIDVGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 17:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgIDVGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 17:06:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8659C061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 14:06:31 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g6so3603930pjl.0
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 14:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PMFm+W1RuhUf/LFlaDXFNwerxxPwAFOd0WGkzl4TRDE=;
        b=bVCVi+mB9FUgoAofMVd8joOvPrrpUhTSGHxCNzM4RVp4EpmTgZx+0vdl6G/a9HYQKi
         2avBQz32htDPsfNKiVujxS2hMTEIfj1RG/4z2VhlGOGEtAgkiLxpjCcy20o8BdJyC0DT
         vCUqK4clBngTMNEHjVHwgnNWs5ltmCrtLty0hvIVUT1Skw0FvR3uk6vvqb+FE+RNPdsF
         dX3nxmYP8z2hgoXR6TF4mVQlddjDoGmao2zppob2uEpdBFNoXJ1+hSJlpY91FiG1LdOE
         y2vJspL2l+GqR1VtD/QDl5sPTFKNWmIHT+3FmPiTgjNSVW9uxJZyvqHRxN0DaWX1J5ZV
         ZPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=PMFm+W1RuhUf/LFlaDXFNwerxxPwAFOd0WGkzl4TRDE=;
        b=feI3jTxuy1hFh9uYseZlFje5Xxu4kRMpvsfEA9rjoqWIfgLORbW4E7idhKx4c09clK
         7ZgWI77wyAGpHt6WmrwRGNZ9ciBXZCgrq/7icGr4QOhYWNij53aZEDY/4C3mKBR5Arku
         RT4okRZd37SMxoLoihV05jJMv24Z7qPwUqnb6+HhsAVF/0HPg3d1VxGrKOD1BS66UNhx
         +7m7OXDoGCDVQwRjrZTH+n6eRkD3HC/rE74k6KCVtuTp9KMZekk+Mx/mMKLNhUIZB7YI
         lcYQ+UMgT2KuVgvT4y9jEJ+kxtWB6xKd59/hXmtUoMtY8WIFZ0SB5m78eG8CakLka5WW
         IVvw==
X-Gm-Message-State: AOAM531UFaS2BdMc2jxboxVlnhSmrkG656qKuD0XzLDPcIMUEAyTionH
        9g1H6UBhWQiagTugCZekyQ45BjfqAO90TkXg
X-Google-Smtp-Source: ABdhPJyKGmDT9y1a+qKv4DlpL2f64PmelFkWKcY+k9VPgvLS+VsAoLsd/qJxt/5JJpAeDaw7zEv2mg==
X-Received: by 2002:a17:90a:640b:: with SMTP id g11mr9722016pjj.176.1599253590815;
        Fri, 04 Sep 2020 14:06:30 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::18a0? ([2620:10d:c090:400::5:817d])
        by smtp.gmail.com with ESMTPSA id t15sm7837599pfl.175.2020.09.04.14.06.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 14:06:30 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.8 io_uring stable
Message-ID: <49361215-3d71-71e8-7cd2-1f7009323a30@kernel.dk>
Date:   Fri, 4 Sep 2020 15:06:28 -0600
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

Linus just pulled 3 fixes from me - 1+2 should apply directly, here's
the 3rd one which will need some love for 5.8-stable. I'm including it
below to preempt the failed to apply message :-)


commit fb8d4046d50f77a26570101e5b8a7a026320a610
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Sep 2 10:19:04 2020 -0600

    io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file
    
    Actually two things that need fixing up here:
    
    - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
      regular files, so don't ever attempt to do that on other types of
      files.
    
    - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
      it. It should just complete with -EAGAIN.
    
    Cc: stable@vger.kernel.org
    Reported-by: Norman Maurer <norman.maurer@googlemail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 82e15020d9a8..96be21ace79a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2726,6 +2726,12 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 				ret = ret2;
 				goto done;
 			}
+			/* no retry on NONBLOCK marked file */
+			if (req->file->f_flags & O_NONBLOCK) {
+				ret = ret2;
+				goto done;
+			}
+
 			/* some cases will consume bytes even on error returns */
 			iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 			ret2 = 0;
@@ -2869,9 +2875,15 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		 */
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
+		/* no retry on NONBLOCK marked file */
+		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
+			ret = 0;
+			goto done;
+		}
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
 				goto copy_iov;
+done:
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:

-- 
Jens Axboe

