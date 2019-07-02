Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B125CC0B
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfGBIdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbfGBIdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:33:04 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122BA206A2;
        Tue,  2 Jul 2019 08:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562056383;
        bh=MUi2xqvCxTjmEa/7/WgDUgBXAztxZHUfRpotLLoirXc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=BUgBU0/KkNvoyatEEBm8gjp5JzIV9kjjGISWyvt+ZKMFkNiZUynXWaJiUrZN/P8/r
         p1cAvalbfmvT8Js856zOSDastuoEVovvH2e0EruSZ9JKHT0/8OBWOqe0yRyIuFX9bx
         uB8Cj4XqWYLukAM8WP/1tjhTToy0F+sV2BGMju24=
Date:   Tue, 2 Jul 2019 10:32:51 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Sebastian Parschauer <s.parschauer@gmx.de>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] HID: Add another Primax PIXART OEM mouse quirk
In-Reply-To: <20190701054817.13991-1-s.parschauer@gmx.de>
Message-ID: <nycvar.YFH.7.76.1907021032360.20818@cbobk.fhfr.pm>
References: <20190701054817.13991-1-s.parschauer@gmx.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Jul 2019, Sebastian Parschauer wrote:

> The PixArt OEM mice are known for disconnecting every minute in
> runlevel 1 or 3 if they are not always polled. So add quirk
> ALWAYS_POLL for this Alienware branded Primax mouse as well.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

