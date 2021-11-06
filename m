Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258E3446CED
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 08:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKFHth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 03:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhKFHtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 03:49:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C848E61073;
        Sat,  6 Nov 2021 07:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636184815;
        bh=4/VuQycASwdj25cRXy5BgwBRayJOj4LdaGfhVqKUesE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MpwlgDYPMTFURH/k4LwVi/bRwH2izyaHFnh0Ir7zvDKQ1GqRtT+YAb/s5YqcmmFWh
         ktHj3nY0zYlVbtvL0LAwpYmFJgg7zPdK6Q2Jtlp/TCbNPfP/BL5H4IC+yazuLQpp99
         6/XhOu+pELzJ7hac47VPG15r3vXIiSW4i+y7o6Jw=
Date:   Sat, 6 Nov 2021 08:46:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Chaney <chaneybenjamini@gmail.com>
Cc:     christian.koenig@amd.com, ray.huang@amd.com, stable@vger.kernel.org
Subject: Re: Regression in 5.10.77: Kernel Oops in amdgpu
Message-ID: <YYYy6MKKDJxaUsZ9@kroah.com>
References: <CAMnhuqRsvOn4zubPb5gQjj4_=FxQZHdccBDk7NxBajsoe3Yffg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMnhuqRsvOn4zubPb5gQjj4_=FxQZHdccBDk7NxBajsoe3Yffg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 05, 2021 at 05:18:50PM -0400, Benjamin Chaney wrote:
> Hello,
>       I am encountering kernel oops shortly after boot (10-15 minutes)
> when running the latest kernel in the 5.10.y series. Git bisect
> suggests that c21b4002214c is the commit that introduced the issue.
> The machine has a AMD Ryzen 7 4800H processor and a Navi 10 graphics
> card. I am happy to provide more information if needed. An excerpt of
> syslog containing the panic is included below.

This commit is queued up to be reverted in the next 5.10.78 release that
will happen in a few hours.  So it should be fixed then, if not, please
let us know.

thanks,

greg k-h
