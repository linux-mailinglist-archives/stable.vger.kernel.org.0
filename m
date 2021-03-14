Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA19E33A784
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCNSde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNSdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 14:33:12 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD360C061574;
        Sun, 14 Mar 2021 11:33:11 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u198so27404942oia.4;
        Sun, 14 Mar 2021 11:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1bU6NjC0SnZeV7Fu48oXhEwNex81yMb6vob2Wzk1Rxw=;
        b=d2wSAzXF5SQ0KZARP6Txa2XTBLCH1AseYtw1cPKF/jz90djMqWHFbqnVnRmzhaPFBT
         TjRSdiRezat38yVQA5+L2fRAvJT4VUisFSfBOMGAuBujCAHyuJcUcC/gCsp88ort9lSM
         PhpZfJcNeSEEZe9SvshTWzQFCTrX3cN8gP1v3xVT9WBwbblIAPN0p8zzqD4y8ZZOs3kl
         4kqaQBGFoNimHq6IwRiP+ARO8azjSQR0tm4YZ+CcQpdvTQrDonZo8ybavUWSOI/RY4mH
         ynlOvTVOb1FY0Oa3y2tGCfLzoPhu+nU/0TUQAVf2vKUZk0j3AJgKxuc94hWx2QkzNN6f
         qGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=1bU6NjC0SnZeV7Fu48oXhEwNex81yMb6vob2Wzk1Rxw=;
        b=Qfj/fuSbMLR5F7US1/C1O2NWiZBtUan838APwhdUJonisorKctHCiV00h4LZG8Hbzn
         LrI5A/WwYBveqxNX5Qd1bsTyG1mBU8lE6QIhCTjjtUnVgShKZOgaAxQRBeQlu2bLvJKi
         HytVD18b/bADiRt8CdNi21znhvxK+/r2q2XQYoZ8zgcXynZa17qhz0VA0/is2tGri6dQ
         96BbwMcGGA7gtjoTBexV6+bd5k1Mp+t6p7l0j4Oy9qD4S/OWokZ7tiDbdhGwWROSUKij
         egYZ47HndePeQWFUzo5vpQZR5VWRTC/uHeUSY+mFmmSZ6Vh+cdGCat4mSOlFVwkPBqEC
         LkOg==
X-Gm-Message-State: AOAM53261BBuTljYxnRLYtvGvb4lgTlUgw74CODavnAhPwVjTgjpElkx
        yuMwQRycglKj/QL3P+0bvJc=
X-Google-Smtp-Source: ABdhPJzVDnZTl2Or/eWhxMjQpI3Vq+UGidiYvkQQIQZgkn0sLbfLIU9ar8lNSthjC4z2hd2vluPZ+Q==
X-Received: by 2002:aca:ac04:: with SMTP id v4mr16122368oie.57.1615746790670;
        Sun, 14 Mar 2021 11:33:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s191sm5470995oie.0.2021.03.14.11.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 11:33:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: alpha patches for v4.4.y / v4.9.y
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <44a392c3-418d-3503-7c46-0d283134d980@roeck-us.net>
Date:   Sun, 14 Mar 2021 11:33:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I recently started to add basic networking tests to my qemu test environment.
When adding the necessary build options to Alpha kernels, I noticed that v4.4.y
and v4.9.y no longer build due to relocation errors such as

net/built-in.o: In function `__copy_tofrom_user_nocheck':
arch/alpha/include/asm/uaccess.h:364:(.text+0xff444):
		relocation truncated to fit: BRSGP against symbol `__copy_user'

The following patches fix the problem.

v4.9.y:

5ed78e5523fd alpha: add $(src)/ rather than $(obj)/ to make source file path
e19a4e3f1bff alpha: merge build rules of division routines
3eec0291830e alpha: make short build log available for division routines
4758ce82e667 alpha: Package string routines together

8525023121de alpha: switch __copy_user() and __do_clean_user() to normal calling conventions

v4.4.y:

5ed78e5523fd alpha: add $(src)/ rather than $(obj)/ to make source file path
e19a4e3f1bff alpha: merge build rules of division routines
3eec0291830e alpha: make short build log available for division routines
4758ce82e667 alpha: Package string routines together

00fc0e0dda62 alpha: move exports to actual definitions
085354f90796 alpha: get rid of tail-zeroing in __copy_user()
8525023121de alpha: switch __copy_user() and __do_clean_user() to normal calling conventions

Only the last patch of each group is really needed; I pulled the other
patches in to avoid conflicts.

Please consider adding those patches to the respective kernels.

Thanks,
Guenter
