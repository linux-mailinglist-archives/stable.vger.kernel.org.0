Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7128F977
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 15:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfD3NDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 09:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfD3NDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 09:03:34 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E4121670;
        Tue, 30 Apr 2019 13:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556629414;
        bh=BKFZi7ZFs00yaqwT0nKxDMBmH9Lz88t5OS09nNcmEsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R29fjbPYSdV+YgqJ10vS8NIu2P6A32AFbhGwABWQZMEMIyA25V0dQlZrm8Ojnro7Q
         J354/NVtD5FU9d+satKi1nTtFMRN8LibfIAyslWQ0cUYxfB/oGCBBtBXyFbUbRJd5e
         rXXJVCWFXn9R0MuezwO+Gx33gF+UgqXN5KeUkNUA=
Date:   Tue, 30 Apr 2019 09:03:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Major Hayden <major@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190430130331.GA6937@sasha-vm>
References: <cki.6C208109D9.WGQF5P41NS@redhat.com>
 <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello CKI folks,

A minor nit: the icon added before the subject text gets filtered out on
the textual email clients most of us use, and ends up appearing (at
least for me) as 3 spaces that cause much annoyance since it gets
confused with mail threading.

I'll work around that by filtering that thingie out using email rules,
but maybe we can avoid sending it out for everyone? :)

--
Thanks,
Sasha
