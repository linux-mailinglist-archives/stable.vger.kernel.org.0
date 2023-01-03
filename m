Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0065BDF5
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 11:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjACKYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 05:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjACKYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 05:24:41 -0500
Received: from forward500c.mail.yandex.net (forward500c.mail.yandex.net [178.154.239.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D476CF597;
        Tue,  3 Jan 2023 02:24:38 -0800 (PST)
Received: from myt6-65ee53fe8ed8.qloud-c.yandex.net (myt6-65ee53fe8ed8.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1d8e:0:640:65ee:53fe])
        by forward500c.mail.yandex.net (Yandex) with ESMTP id 91D055EB13;
        Tue,  3 Jan 2023 13:24:28 +0300 (MSK)
Received: by myt6-65ee53fe8ed8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id ROTZMa0ZMGk1-Nd5t1DAM;
        Tue, 03 Jan 2023 13:24:28 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=skif-web.ru; s=mail; t=1672741468;
        bh=Htu8XEzBUxxl6I2Gtq9JSZxi+WwMB2ca8r0VPmnTRUw=;
        h=Message-ID:Subject:References:To:From:In-Reply-To:Cc:Date;
        b=kQ157ioro3rrM9veYvSdWGEbX1HSxsVNLE5wsR8kQgX4gSUXfFwdHI5d8j5dDRWzh
         Sl6PH00T+L2gj/EddRXuUKzkFwoLuMdTyxDtKZ7WI3EcGjRyPgsnuIxL4AHwA5NDbH
         Cp5LH/A8P3axuoZw88JfvVVmHusuXB8R9XQERs08=
Authentication-Results: myt6-65ee53fe8ed8.qloud-c.yandex.net; dkim=pass header.i=@skif-web.ru
Date:   Tue, 3 Jan 2023 13:24:26 +0300
From:   Alexey Lukyachuk <skif@skif-web.ru>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
Message-ID: <20230103132426.0c6d144f@alexey-Swift-SF314-42>
In-Reply-To: <87a630ylg5.fsf@intel.com>
References: <20221225184413.146916-1-skif@skif-web.ru>
        <20221225185507.149677-1-skif@skif-web.ru>
        <Y6sfvUJmrb73AeJh@intel.com>
        <20221227204003.6b0abe65@alexey-Swift-SF314-42>
        <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
        <87a630ylg5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NO_DNS_FOR_FROM,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Jan 2023 12:14:02 +0200
Jani Nikula <jani.nikula@linux.intel.com> wrote:

> On Mon, 02 Jan 2023, Alexey Lukyachuk <skif@skif-web.ru> wrote:
> > Regarding to your question about fdo gitlab, I went to do it.
> 
> What's the URL for the issue?
> 
> BR,
> Jani.
> 

I have not submited issue in bug tracker because I found solution in git.
("Before filing the bug, please try to reproduce your issue with the 
latest kernel. Use the latest drm-tip branch from 
http://cgit.freedesktop.org/drm-tip and build as instructed on 
our Build Guide.")

Should I do it?
