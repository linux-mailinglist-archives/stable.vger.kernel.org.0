Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BC22436A
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfETWXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:23:45 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:55981 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfETWXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:23:45 -0400
Received: by mail-it1-f195.google.com with SMTP id g24so1663696iti.5
        for <stable@vger.kernel.org>; Mon, 20 May 2019 15:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1CaXJMTXc57iqkntwEjIR8nDiCsro9FbdDpUP4+PfJc=;
        b=Ay6eeb6e5aKiQdi0pweGEDPMMxlx/Mn2AvwEsYkp3UpuDjZhiA40w0+FilAVPXIMnw
         Alw2aI5RZtIReQYrEqmA++hBDywsBwMx1bOHkhAJeokOOyZXHQjGP1OyKnXw7ao89mpC
         cZID47+1S6e/pVCm56lUdkxGM4n9ydbzFPSaZhAhltE5fIEyA0E5Au01Qkpy+1pZosUn
         gAfoMMwWMzjOh1Mg+xuUq7Kfqj2y0FnHmSzlhsTYL8GAUU8Fg2hqHMn7zAXQJdym+kdw
         7N6Ta16knmQQsOF+5hsv40DvHKn5oUBn2GMN86tN84GSyaNRrzq+mE2I+k57ZDbB9whh
         t2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1CaXJMTXc57iqkntwEjIR8nDiCsro9FbdDpUP4+PfJc=;
        b=ZJhnOtqNhp3ugXJ0m0BbBjZoxkx9RahoorZG475ohx4b7aAFsUb3fH/Yug+slOX5AA
         gK8G49/Ry5VKvxDtrecVQX1QeJ+2Ugt4Tld1dNQfqPWUVKb/nWvvu3+VFfvIWAhsPfQs
         IvTyxEbLyGSej5qVLqmrjQq62zOd9/uQuPkI894OY/7IGJjuMHzHysBO2zFZMG8kIHbv
         Cb8GINa3YDsl8gt2w4AC3N65OFj7VEMlKK4js5AIVESg/d2BGRIyw4tJEQfKO7Sf6iPe
         uLuk6AtXrhOp1AORRTK1+kEwzQKHKB4LOXNawtRedsKForbPOPYGnzrnyXja7eRtTZpz
         1Rjg==
X-Gm-Message-State: APjAAAWn+6qoYoiOJhiWOnvAymUtTtPD4iKvMfZcrntY8MkIbBXumLhk
        i2vpVqdoStbqdP3hR2ZBaVqm0Q==
X-Google-Smtp-Source: APXvYqwaTj+wVvNaJbKY/DhmG1joPIZeyJ/GlYIHhg0g6g9QL5lnynyySYJi6RXpoOpFMLcf9hokhQ==
X-Received: by 2002:a24:2bd3:: with SMTP id h202mr1291405ita.115.1558391024396;
        Mon, 20 May 2019 15:23:44 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id q72sm501224ita.26.2019.05.20.15.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 15:23:43 -0700 (PDT)
Date:   Mon, 20 May 2019 17:23:42 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4.19 000/105] 4.19.45-stable review
Message-ID: <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
References: <20190520115247.060821231@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 02:13:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.45 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> Anything received after that time might be too late.

We're seeing an ext4 issue previously reported at
https://lore.kernel.org/lkml/20190514092054.GA6949@osiris.

[ 1916.032087] EXT4-fs error (device sda): ext4_find_extent:909: inode #8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent entries - magic f30a, entries 8, max 340(340), depth 0(0)
[ 1916.073840] jbd2_journal_bmap: journal block not found at offset 4455 on sda-8
[ 1916.081071] Aborting journal on device sda-8.
[ 1916.348652] EXT4-fs error (device sda): ext4_journal_check_start:61: Detected aborted journal
[ 1916.357222] EXT4-fs (sda): Remounting filesystem read-only

This is seen on 4.19-rc, 5.0-rc, mainline, and next. We don't have data
for 5.1-rc yet, which is presumably also affected in this RC round.

We only see this on x86_64 and i386 devices - though our hardware setups
vary so it could be coincidence.

I have to run out now, but I'll come back and work on a reproducer and
bisection later tonight and tomorrow.

Here is an example test run; link goes to the spot in the ltp syscalls
test where the disk goes into read-only mode.
https://lkft.validation.linaro.org/scheduler/job/735468#L8081

Dan

-- 
Linaro - Kernel Validation
