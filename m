Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371F22C689B
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 16:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgK0PS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 10:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgK0PS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 10:18:26 -0500
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFAA2223F;
        Fri, 27 Nov 2020 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606490305;
        bh=MVzobAdIIjRd7ukdycmlVCd+JTbqM8bKr+p+bLZKauk=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=hNGitFvxrKE32FML335leET213jzlL75JIrs/QiCkZScs2HCk6Tn3U7o3yKZ/zXZP
         dxVjNsmi/4p9dLxSrPYP3ZO0G1B1gYyfwb/gvo5Qgo9/nnwabc8oHsmL6gWGAc8Utz
         sb7bLJnhBPmsF4AbwA+6YPJbYgvYmj95/7iNkEAI=
Date:   Fri, 27 Nov 2020 16:18:22 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Julian Sax <jsbc@gmx.de>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add Vero K147 to descriptor override
In-Reply-To: <20201126175158.1183879-1-jsbc@gmx.de>
Message-ID: <nycvar.YFH.7.76.2011271618120.3441@cbobk.fhfr.pm>
References: <20201126175158.1183879-1-jsbc@gmx.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 26 Nov 2020, Julian Sax wrote:

> This device uses the SIPODEV SP1064 touchpad, which does not
> supply descriptors, so it has to be added to the override list.

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs

