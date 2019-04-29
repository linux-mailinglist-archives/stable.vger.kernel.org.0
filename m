Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A105CE1E1
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfD2MFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:05:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35106 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbfD2MFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 08:05:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id y197so15408715wmd.0;
        Mon, 29 Apr 2019 05:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=20OOFr0oVOG3w2tDZNbxmeNviUJCH2+i2oLY/RHV008=;
        b=JO93+Zd8tjqmorRYNflToRliUbhCKK5M21vq9vLHkRNDCFRlVVKVTuxlxHqSr/fnuB
         JL8os2aJKJUI1EVOX/eQnvS0Yv2/kH/CwFI+DhhSOyTMelMH5wPi1mmsPPT1wYpBiO4t
         M7wR5chm33A5fRGtpXvEGJCAgy19+ts98hEvYL+AuXDGhC/XAsxVoH9Fkq2PIGOAfKmw
         LQi2S3+EEgmztn6i7l4T1kDO8KVlnWuV0bDHNM20+A2tRcHBmeY/qGt8ePCO1sYZTRwA
         ol8xp1YnibDI9cSpsiz5id0DklVX4tCDskHZ3loBYI7vrfJRb0epSOInLyIN+1WBYHeq
         D++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=20OOFr0oVOG3w2tDZNbxmeNviUJCH2+i2oLY/RHV008=;
        b=rCXlZ3GBbIwAMeW2DSNVzg2QAhjMxf+pVHkhHfLQdn8pur7v5TcPoz39KNNi3cou3Q
         n7zw99kzfTqEPGKqGsx4wHVE2l7w4DXCK9GCP91aFnvadMA/9tMVCD+RAc0NO69L6rFg
         faF4ppX+89KapgBXu5CyNXm+N36B37ewf1RueOmQDFQEgbVrUQL/DAaCLf5oeaC5cN8D
         Anc+3RWTOEATwEyVC3UL7IC20G1lMr664PU7gbTpLZAgLc1wAcI+3S3/avQXaSU7gUnc
         mU9Hg1Ni+yq4WF3a7NqgeIFdRFbIlHqTn0QbqXkVDVgetBC1R2NNaOyudrPvrMPPnwbo
         p5nw==
X-Gm-Message-State: APjAAAUYBsmjZgeC7I2/5Z69h8BbVr/21zLte7c8nfbQ4uuiYykIjMef
        Vy8McT93DX+1BKlt+lX74CCdMPRGJHY=
X-Google-Smtp-Source: APXvYqyCR3xeg68owtki/FaZ1ocnf+R+zsT5L1/6gp47ZgExmjY0bREset3gyISWSH62B/rUJc+wCg==
X-Received: by 2002:a7b:c218:: with SMTP id x24mr4555674wmi.57.1556539544773;
        Mon, 29 Apr 2019 05:05:44 -0700 (PDT)
Received: from lorien (lorien.valinor.li. [2a01:4f8:192:61d5::2])
        by smtp.gmail.com with ESMTPSA id q4sm35120101wrx.25.2019.04.29.05.05.43
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 05:05:43 -0700 (PDT)
Date:   Mon, 29 Apr 2019 14:05:42 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        928125@bugs.debian.org, Brad Barnett <debian-bugs2@L8R.net>
Subject: Re: Revert commit 310ca162d77
Message-ID: <20190429120542.wybwf5vqwzhv6nkf@lorien.valinor.li>
Mail-Followup-To: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, 928125@bugs.debian.org,
        Brad Barnett <debian-bugs2@L8R.net>
References: <20190320125806.GD9485@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320125806.GD9485@quack2.suse.cz>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan, hi Greg,

On Wed, Mar 20, 2019 at 01:58:06PM +0100, Jan Kara wrote:
> Hello,
> 
> commit 310ca162d77 "block/loop: Use global lock for ioctl() operation." has
> been pushed to multiple stable trees. This patch is a part of larger series
> that overhauls the locking inside loopback device upstream and for 4.4,
> 4.9, and 4.14 stable trees only this patch from the series is applied. Our
> testing now has shown [1] that the patch alone makes present deadlocks
> inside loopback driver more likely (the openqa test in our infrastructure
> didn't hit the deadlock before whereas with the new kernel it hits it
> reliably every time). So I would suggest we revert 310ca162d77 from 4.4,
> 4.9, and 4.14 kernels.

A user in Debian reported [1], providing the following testcase which showed up
after the recent update to 4.9.168-1 in Debian stretch (based on upstream
v4.9.168) as follows:

	dd if=/dev/zero of=/tmp/ff1.raw bs=1G seek=8 count=0
	sync
	sleep 1
	parted /tmp/ff1.raw mklabel msdos
	parted -s /tmp/ff1.raw mkpart primary linux-swap 1 100
	parted -s -- /tmp/ff1.raw mkpart primary ext2 101 -1
	parted -s -- /tmp/ff1.raw set 2 boot on
	sleep 5
	losetup -Pf /tmp/ff1.raw --show

I have verified that the same happens with v4.9.171 where the mentioned commit
was not reverted, and bisecting of the testcase showed it was introduced with
3ae3d167f5ec2c7bb5fcd12b7772cfadc93b2305 (v4.9.152~9) (which is the backport of
310ca162d77 for 4.9).

Reverting 3ae3d167f5ec2c7bb5fcd12b7772cfadc93b2305 on top of v4.9.171 worked
and fixed the respective issue.

Can this commit in meanwhile be reverted or is there further ongoing work in
integrating the followup fixes as mentioned in
https://lore.kernel.org/stable/20190321104110.GF29086@quack2.suse.cz/ .

Regards,
Salvatore

 [1] https://bugs.debian.org/928125
