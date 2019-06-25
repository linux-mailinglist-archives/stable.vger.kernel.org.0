Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 592B3521D9
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 06:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfFYERG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 00:17:06 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40635 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfFYERG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 00:17:06 -0400
Received: by mail-pg1-f172.google.com with SMTP id w10so8231592pgj.7
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 21:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=dWuOBhD4UEmF6cKDSqipZ42vdcko/cxP023c878sIiM=;
        b=fampbzMKYBRwzWwOKoNAwvl7YhxJDYowciIndj1HPhd6kOeoT0zIDTJ2p2n0lYi/ZF
         +Elhu6MHInOig3LxHM2nie2zp6oKTq/3THPeVfpe7mQt409kabgYHl/SnJOelzULt3vq
         MEDevtYr8JtOx8nEbbLBDhKFje6GIR8xf9WqHZ8lwWfyuiqAv0SbN1JVYqZhUihMh+mN
         uv6fxytgBOeJNkmsMxume5ZPmzPlBoJ/SIQQig3DuYAF9bKaDMTAjYPNPpBaaOQWoF5t
         NH8QFu6CuTCr1ZhCQQfRQRWpVFjjDgxVDOF0zYS9ToE7TH8KhSkr4fVhrQxHOK/qqh7u
         AX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=dWuOBhD4UEmF6cKDSqipZ42vdcko/cxP023c878sIiM=;
        b=LGewfRudwac4ZCWKCCn+/Offc8hcNPxZa+6r8Uy+a7C+kKtuiP9yK3mTNsAeTkfFee
         KyvCLz0y2+IvYhoBIZfdKcgb/hU3NMAYFSB/0igIotZLtt7ZjcPiH3Tj1+rZ2dtFvFYk
         Qa+eC4G7c9/0kM0/6hXU1uTEAuEnLl6MoxLqeC3NMKZQa4dWZkzYTqlVqYyaSorhxC2v
         CgBngKAIKuYAMggwJ6Y7+3Boa4ISSwQpQ1cfjEtJi8DAva6tSJP3NkOysfyd90rJSXeR
         IlTTUhhy6wAULSQBqoo2beP1OoZOVG7EB3BcWGjaZoBXNc/8CCPNPmph4YRjHv5E9H+O
         cwZg==
X-Gm-Message-State: APjAAAWvSyuJLQlTJy2M1pCvSPTLscEZBeUQvHYM16kj5xvJoZFCqw7R
        /h5OXRE8DBGCa8x4gM95qXZ9OuFk3DM=
X-Google-Smtp-Source: APXvYqz8LGGDBdptsmnKuOETNCzPw0zYCX55y0pmanKXPgmM1ZVnGUGGtbgaFZpEYLBm9Z3FfNK8vg==
X-Received: by 2002:a63:3d8d:: with SMTP id k135mr29604973pga.23.1561436224928;
        Mon, 24 Jun 2019 21:17:04 -0700 (PDT)
Received: from Gentoo ([103.231.91.68])
        by smtp.gmail.com with ESMTPSA id q4sm859890pjq.27.2019.06.24.21.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:17:03 -0700 (PDT)
Date:   Tue, 25 Jun 2019 09:46:53 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: Failed to checksum on tarball latest kernel 5.1.15
Message-ID: <20190625041653.GA10886@Gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I got this :

 Check the latest stable kernel version from kernel.org 

5.1.15 
Get the kernel from kernel.org and this for the *stable* kernel 


Using TMPDIR=/home/bhaskar/latest_kernel_build_Gentoo_2019-06-25/linux-tarball-verify.XwbUNj.untrusted
Making sure we have all the necessary keys
gpg: WARNING: unsafe ownership on homedir '/home/bhaskar/.gnupg'
pub   rsa4096 2013-01-24 [SC]
      B8868C80BA62A1FFFAF5FDA9632D3A06589DA6B1
uid           [ unknown] Kernel.org checksum autosigner <autosigner@kernel.org>

pub   rsa4096 2011-09-23 [SC]
      647F28654894E3BD457199BE38DBBDC86092693E
uid           [ unknown] Greg Kroah-Hartman <gregkh@linuxfoundation.org>
uid           [ unknown] Greg Kroah-Hartman (Linux kernel stable release signing key) <greg@kroah.com>
uid           [ unknown] Greg Kroah-Hartman <gregkh@kernel.org>
sub   rsa4096 2011-09-23 [E]

pub   rsa2048 2011-09-20 [SC]
      ABAF11C65A2970B130ABE3C479BE3E4300411886
uid           [ unknown] Linus Torvalds <torvalds@kernel.org>
uid           [ unknown] Linus Torvalds <torvalds@linux-foundation.org>
sub   rsa2048 2011-09-20 [E]

Downloading the checksums file for linux-5.1.15
Verifying the checksums file
gpgv: Signature made Sat Jun 22 15:01:21 2019 IST
gpgv:                using RSA key 632D3A06589DA6B1
gpgv: Good signature from "Kernel.org checksum autosigner <autosigner@kernel.org>"

Downloading the signature file for linux-5.1.15
Downloading the XZ tarball for linux-5.1.15
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  101M  100  101M    0     0  8237k      0  0:00:12  0:00:12 --:--:-- 8342k
Verifying checksum on linux-5.1.15.tar.xz
/usr/bin/sha256sum: /home/bhaskar/latest_kernel_build_Gentoo_2019-06-25/linux-tarball-verify.XwbUNj.untrusted/sha256sums.txt: no properly formatted SHA256 checksum lines found
FAILED to verify the downloaded tarball checksum


