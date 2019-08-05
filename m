Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D537E818F6
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 14:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfHEMPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 08:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfHEMPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 08:15:52 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1DBA2086D;
        Mon,  5 Aug 2019 12:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565007351;
        bh=6OPANB7+aRSQoQm0kWI9Ad2u/iDEGYOeFHZ4eswhNuw=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=0TL8LsPz+MxCaOUXANCHDbijByfgJWe5fRLIilB8JQiqQirbDsZtSXWboqVbUSCEe
         XQ5h3Rx+1aymrtjk0aHzSnLoG1HV0UAKuQzEDfphTSicRLpLyVocnZ/ecjy0v6zDPf
         EaQmmWrSNAT3WlraXCn5Ytdx5NcnQSog5/1+1KiE=
Date:   Mon, 5 Aug 2019 14:15:46 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Aaron Armstrong Skomra <skomra@gmail.com>
cc:     linux-input@vger.kernel.org, benjamin.tissoires@redhat.com,
        pinglinux@gmail.com, jason.gerecke@wacom.com,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 5+" <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: wacom: fix bit shift for Cintiq Companion 2
In-Reply-To: <1563905355-20921-1-git-send-email-aaron.skomra@wacom.com>
Message-ID: <nycvar.YFH.7.76.1908051415290.5899@cbobk.fhfr.pm>
References: <1563905355-20921-1-git-send-email-aaron.skomra@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jul 2019, Aaron Armstrong Skomra wrote:

> The bit indicating BTN_6 on this device is overshifted
> by 2 bits, resulting in the incorrect button being
> reported.
> 
> Also fix copy-paste mistake in comments.
> 
> Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
> Link: https://github.com/linuxwacom/xf86-input-wacom/issues/71
> Fixes: c7f0522a1ad1 ("HID: wacom: Slim down wacom_intuos_pad processing")
> Cc: <stable@vger.kernel.org> # v4.5+

Applied to for-5.3/upstream-fixes. Thanks,

-- 
Jiri Kosina
SUSE Labs

