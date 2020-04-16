Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF341AD079
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 21:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731397AbgDPTjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 15:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgDPTjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 15:39:40 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F5D21BE5;
        Thu, 16 Apr 2020 19:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587065980;
        bh=oeXqg4Uz21hvCN3wmWUjN4JFnUaz5tc5mND5b0ompJM=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=CxlT/4Fn46PPatB8z8hTpOtDy7cQcTexnJv+UorsodgfIxS9UXdtflhNS1m9+Tz8l
         DQc4FIJ8QuOp64967cZupb1uiz00B+5SDBADM0Igj5EH+wr75FgkFlXEqouPsyWHBQ
         5Pw4T952yEORSM2KeJHh73hyODhtzRIwrgcUmxc8=
Date:   Thu, 16 Apr 2020 21:39:36 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Gerecke, Jason" <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "HID: wacom: generic: read the number of expected
 touches on a per collection basis"
In-Reply-To: <20200408145837.21961-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2004162139190.19713@cbobk.fhfr.pm>
References: <20200408145837.21961-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Apr 2020, Gerecke, Jason wrote:

> From: Jason Gerecke <killertofu@gmail.com>
> 
> This reverts commit 15893fa40109f5e7c67eeb8da62267d0fdf0be9d.

Pushed to hid.git#for-5.7/upstream-fixes, sorry for the delay.

-- 
Jiri Kosina
SUSE Labs

