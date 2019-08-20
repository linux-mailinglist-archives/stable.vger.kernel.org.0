Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BD995A07
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 10:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfHTIn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 04:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728545AbfHTIn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 04:43:28 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E88823777;
        Tue, 20 Aug 2019 08:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566290607;
        bh=yVHdciJ6Uf7f0XT+WZlY2UlBsVWUFoNWCV7vCgtCN7s=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=yt5ZNkw/0l/1ehGE9jhqxA/jYLiAKZhEu9WjGCFI2Lkh1d+AdJqDDNJGW56GlZqfA
         fIxSpRV72y/4HCQMan2DU+W5ndr9dAt5ItcwnyHu0Aon9tqkwLA0+sCXlooJZ0hfhR
         lGr+x1pYJ7fW/dvcqRQffAauX7NQzErwIRmoP7CE=
Date:   Tue, 20 Aug 2019 10:43:17 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Aaron Armstrong Skomra <skomra@gmail.com>
cc:     linux-input@vger.kernel.org, benjamin.tissoires@redhat.com,
        ping.cheng@wacom.com, jason.gerecke@wacom.com,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 3+" <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: wacom: correct misreported EKR ring values
In-Reply-To: <1565982054-29236-1-git-send-email-aaron.skomra@wacom.com>
Message-ID: <nycvar.YFH.7.76.1908201043020.27147@cbobk.fhfr.pm>
References: <1565982054-29236-1-git-send-email-aaron.skomra@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Aug 2019, Aaron Armstrong Skomra wrote:

> The EKR ring claims a range of 0 to 71 but actually reports
> values 1 to 72. The ring is used in relative mode so this
> change should not affect users.
> 
> Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
> Cc: <stable@vger.kernel.org> # v4.3+
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
> Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>

Queued for 5.3, thanks Aaron.

-- 
Jiri Kosina
SUSE Labs

