Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40499231D
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHSMJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 08:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbfHSMJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 08:09:47 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D290520851;
        Mon, 19 Aug 2019 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566216586;
        bh=AFmeCjxPOgW7lBsTh+bPGQgonG8ZoeL5U6tprT7xeMI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Te/E0k6R1jF9b2pzJqDPextjL12iQWf9hN2BcnzSr/+n3FHH5bRcAXC7AO9OyR1BP
         2xkW9vjBqLj+2MZu0GOjvVkVC8Jcki6SvuhXfoL2MdCXLg/nhKEHGyvT66MDg6VaKM
         vbsknTMVzDprVTajze8D3f1/kz5iW1JDSbjlpN9Y=
Date:   Mon, 19 Aug 2019 14:09:36 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Gerecke, Jason" <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] HID: wacom: Correct distance scale for 2nd-gen Intuos
 devices
In-Reply-To: <20190807211155.4280-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.1908191409220.27147@cbobk.fhfr.pm>
References: <20190807051839.GA26833@kroah.com> <20190807211155.4280-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 7 Aug 2019, Gerecke, Jason wrote:

> From: Jason Gerecke <jason.gerecke@wacom.com>
> 
> Distance values reported by 2nd-gen Intuos tablets are on an inverted
> scale (0 == far, 63 == near). We need to change them over to a normal
> scale before reporting to userspace or else userspace drivers and
> applications can get confused.
> 
> Ref: https://github.com/linuxwacom/input-wacom/issues/98
> Fixes: eda01dab53 ("HID: wacom: Add four new Intuos devices")
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Cc: <stable@vger.kernel.org> # v4.4+

Applied to for-5.3/upstream-fixes. Thanks,

-- 
Jiri Kosina
SUSE Labs

