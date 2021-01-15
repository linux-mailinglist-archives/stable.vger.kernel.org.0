Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599EC2F73C3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbhAOHjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731639AbhAOHjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 02:39:03 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F331C0613C1
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 23:38:22 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id n142so10917451qkn.2
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 23:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:mime-version:content-transfer-encoding
         :date:message-id;
        bh=ktDrzFaK7ZKVRifcI3ySc5fSo9wFsO2J6WtcFxC2vW0=;
        b=mNiEk6XXKiSBT7clntbHzmKQdfC/dEu6sgAXKwfc7nhKVJkOgwUmb6mM4mYJtiivtg
         77Vepp6DF2Dw4tF+q/6Y991kixrZETmtsqgPeXKwNCYv9rlGwsswjcw6CZR4CgL/xSXe
         YOX4Z8XQhT+ZN/BGZoq3fKLy1qHsS8NdlSM/0A4z0SJ1H+jjEKDx47arLUTLgPAW8FAQ
         NfZj/Y0AhBjkvZXZSj4A1tcYgHBdpg8ayvG6mYFoFoIsaB7x/BLlyn5OxTtqizu4N+bY
         Zfoc4UJD6T+Dm+xgem5fdXoWXw8RiUY2pAWZ9pNJu2YorjYH/ccgX0N9rMdQWq8a2cj/
         1AAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version
         :content-transfer-encoding:date:message-id;
        bh=ktDrzFaK7ZKVRifcI3ySc5fSo9wFsO2J6WtcFxC2vW0=;
        b=MmrNcKJhhrHXNfLEKX48Brw7XXZCA2vn7uCF9TgG9WsFa0VoocYkuW79IBuQdc5hy6
         Q6uDHaEPmviKH6BU1yYY2kvkUzJiJL5LkN+cHKCtoXrsmh+NKI1HJyetjTd6DkXROG/Z
         qyFMPR17Qa1VDeSGI13/gxsoR/32pDw6Z/e3pamXHm72eSq6c8BplfCDmtc4bDaDVkJE
         ay93bpdlQ6k/J3XHzFy5Jz9XPNMuN7WQrBJIrEuEZAqas3IsddqDr7dn/22alTJysiE8
         0mySFAofTi6gjD1/7J/a/5ProbSy/Y7h+OwA5qHHHtPvWv9xtlT7o03A3tsalNv6BKfm
         X2oA==
X-Gm-Message-State: AOAM533YkjvKrgXHXICHO1uTzs3/7U96etpbqiPAGwnhwkEfWU4H2nEZ
        cFfl6znMHg+Se4CWgFEJLNrdNmAl9pt7ZA==
X-Google-Smtp-Source: ABdhPJwuTZljndMa/l6TmyBz4KU7xkIsV85IyLVRF9Wt6NUIhUigAy8ee9cjZNWM2VwkOnvVeO8UUQ==
X-Received: by 2002:a37:a8a:: with SMTP id 132mr10980189qkk.327.1610696301890;
        Thu, 14 Jan 2021 23:38:21 -0800 (PST)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id q27sm4483033qkj.131.2021.01.14.23.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 23:38:20 -0800 (PST)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Greg KH <greg@kroah.com>, arpad.mueller@uni-bonn.de
cc:     stable@vger.kernel.org
Subject: [PATCH] For 5.4 stable exfat: Month timestamp metadata accidentally incremented
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 15 Jan 2021 02:38:19 -0500
Message-ID: <6161.1610696299@turing-police>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The staging/exfat driver has departed, but a lot of distros are still tra=
cking
5.4-stable, so we should fix this.

There was an 0/1 offset error in month handling for file metadata, causin=
g
the month to get incremented on each reference to the file.

Thanks to Sebastian Gurtler for troubleshooting this, and Arpad Mueller
for bringing it to my attention.

Relevant discussions:
https://bugzilla.kernel.org/show_bug.cgi?id=3D210997
https://bugs.launchpad.net/ubuntu/+source/ubuntu-meta/+bug/1872504

Signed-off-by: Valdis Kletnieks <valdis.kletnieks=40vt.edu>

diff --git a/drivers/staging/exfat/exfat_super.c b/drivers/staging/exfat/=
exfat_super.c
index 3b2b0ceb7297..848258daf620 100644
--- a/drivers/staging/exfat/exfat_super.c
+++ b/drivers/staging/exfat/exfat_super.c
=40=40 -59,7 +59,7 =40=40 static void exfat_write_super(struct super_bloc=
k *sb);
 /* Convert a FAT time/date pair to a UNIX date (seconds since 1 1 70). *=
/
 static void exfat_time_fat2unix(struct timespec64 *ts, struct date_time_=
t *tp)
 =7B
-	ts->tv_sec =3D mktime64(tp->Year + 1980, tp->Month + 1, tp->Day,
+	ts->tv_sec =3D mktime64(tp->Year + 1980, tp->Month, tp->Day,
 			      tp->Hour, tp->Minute, tp->Second);
=20
 	ts->tv_nsec =3D tp->MilliSecond * NSEC_PER_MSEC;

