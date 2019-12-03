Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E0110F882
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 08:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfLCHPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 02:15:08 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40583 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfLCHPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 02:15:07 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so1322702plp.7
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 23:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N5dhLN6ZUdZy7qbcrhFqRDkTAyaEydaPR0KSp4d1Kkw=;
        b=rYVX22ng5y9nwctMuRjTWiQ78ZIhUqR2NFU5z0/XMqLENE+whBXd2uL4Bga8Gt9nWW
         T3LTOWRj6vsp050f6x6dTqL6QIJ0NqpG4EUwbukpiHaaGk3XIP1d6tfJ/Jj3SQTLSYDc
         CSZDKqGaP/B3ClQPOFh4sSNj+0/3bAAf8lcFNsO6jLS78Ps+w/ZCpXfNKYUEP30nmWMt
         LXVfSvzQ3vValVOtMVBjOjQtl9c35c8bvrsoU2kv7YzItEILFKRaZD4+x6apZbAuw5BD
         hRhZ1/0OO9W8zrbmwrCtMVJJS2Ct6m9eDsmJvb3htNkl6g9x9uFwezApA62G7lFwZl3m
         Lk4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N5dhLN6ZUdZy7qbcrhFqRDkTAyaEydaPR0KSp4d1Kkw=;
        b=hf0u1VtYSnpNOdrWpBLW6srARBoK9oA8NBYyiBIU3e0kEeyK4sVYgUFmNy1mOfp0yL
         uxNqfmffTjnOWBqKyJThnLYr8b8/1dOw4BAOQmDMrB9Tob9NfzZR2qmtK6mBLxANFD0s
         kwgpP0nV3d3hIZmiOfTUsbs28QjwtjKvPkA34/oE3LdGKhzbBDfdtY2ugdEAiPycieya
         WkxjfDTnSaaPKyx9BJIHtr70sCnkKlvtq6Gb2AaTVf+lKrL9uJGsEMOxGJzibcP2MXZX
         zcVaYt/NctzmrPxOAmsgtS1qSsZbtv6Xz80sbQps+NIRyFKFtehnBHYiEimw2R9wy56+
         F5ZA==
X-Gm-Message-State: APjAAAWALNt44PwpO7Yde7qbZ7+62kwz4CF5g8Jmb7vSb4HjstyGuFiL
        3RabJcBEJ42Rf/xfuf+m0FJYtwYw
X-Google-Smtp-Source: APXvYqyTkUDH0DmgvUPwBfGldopMG8dI8qMv8/QU5E5sVhn1JWvVmo07QrR7aU3udiAnvAuD7l14VA==
X-Received: by 2002:a17:90a:8685:: with SMTP id p5mr3964852pjn.92.1575357307187;
        Mon, 02 Dec 2019 23:15:07 -0800 (PST)
Received: from workstation-portable ([139.5.253.93])
        by smtp.gmail.com with ESMTPSA id u65sm2054215pfb.35.2019.12.02.23.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 23:15:06 -0800 (PST)
Date:   Tue, 3 Dec 2019 12:44:15 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [STABLE TEST] 5.3.13
Message-ID: <20191203071415.GA9640@workstation-portable>
References: <20191203062503.GA3467@workstation-kernel-dev>
 <20191203064052.GA1788679@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203064052.GA1788679@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 07:40:52AM +0100, Greg KH wrote:
> On Tue, Dec 03, 2019 at 11:55:03AM +0530, Amol Grover wrote:
> > Compiled, Booted, however I'm getting the following errors when running
> > "make kselftest"
> > 
> > sudo dmesg -l alert
> > 
> > [34381.903893] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > [34381.903904] #PF: supervisor read access in kernel mode
> > [34381.903908] #PF: error_code(0x0000) - not-present page
> 
> Which test causes this problem?

IIRC I didn't run make kselftest with summary=1 option. Is there any
other way to get that information? The logs that kselftest generated
also don't seem to help in this.

> 
> ANd is it new in 5.3.13?
> 

I previously ran kselftest on 5.4-rc7 and 5.3.9 (default kernel shipped
by openSUSE), both were fine. However, a bit of backstory:

A day ago I used kselftest from the linux/next branch and ran it (w/o
sudo).  It showed me the exact same error. However, I was running a
modified version of 5.3.13, but those modifications were actually
trivial (5 lines changed) and shouldn't have resulted in this kernel
error. So, I switched to the vanilla 5.3.13 and ran kselftest (w/o sudo)
again. I ran it 3 times (w/o any errors), switched back to the modified
kernel and ran kselftest (w/o root) 2 more times and everything was
fine. Then I decided to test the vanilla one again for the 4th time, but
this time I ran kselftest as root where this BUG popped again.

Thanks
Amol


> thanks,
> 
> greg k-h
