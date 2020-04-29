Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20021BE7BB
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 21:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgD2Tsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 15:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgD2Tsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 15:48:32 -0400
Received: from pobox.suse.cz (unknown [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2069B206D6;
        Wed, 29 Apr 2020 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588189407;
        bh=KvYlEUXkK+PUsHr1w5AnUqjWqIRHSUm9pdRu2b3JXSc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=gNXMVZOKu20UOyMRlvh/WAl35MxB6IHcwHyLpY9sOlbaPdG7QyjXx25x3lore8L1T
         5IwtTrRnVigu8MtSyDo2VwbabEkw4VBjfgokpOgvtJutM/puHjcBESu65EVXJsqOP1
         OuPAvXfqOiGD29uI+ozGV92OkyPrRrIUrCcY27A8=
Date:   Wed, 29 Apr 2020 21:43:24 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Report 2nd-gen Intuos Pro S center button
 status over BT
In-Reply-To: <20200424210400.220712-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2004292142500.19713@cbobk.fhfr.pm>
References: <20200424210400.220712-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 24 Apr 2020, Jason Gerecke wrote:

> The state of the center button was not reported to userspace for the
> 2nd-gen Intuos Pro S when used over Bluetooth due to the pad handling
> code not being updated to support its reduced number of buttons. This
> patch uses the actual number of buttons present on the tablet to
> assemble a button state bitmap.
> 
> Link: https://github.com/linuxwacom/xf86-input-wacom/issues/112
> Fixes: cd47de45b855 ("HID: wacom: Add 2nd gen Intuos Pro Small support")
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Cc: stable@vger.kernel.org # v5.3+

Applied, thanks Jason.

-- 
Jiri Kosina
SUSE Labs

