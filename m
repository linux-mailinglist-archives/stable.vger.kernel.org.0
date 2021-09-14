Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB82C40A6F8
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 08:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbhING6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 02:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbhING6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 02:58:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95829C061574;
        Mon, 13 Sep 2021 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vPUlUbzkiqu+rcv52nE0RTFyv/GxprjJ7JCufB/wTvg=;
        t=1631602616; x=1632812216; b=yH3bnixwvdtZl6rY0R3+TMAvyhVYA9sRRd1FzyRzE8FOBWd
        FyQ3AzpegaxSg731hHTDvA+hPIwckMd087k6M3+soNE/tT9AE0C2LpR1J6EUtuJdqSzZkmUznr/3h
        FFk8i67XmVPKJs+ihbvJ0sdbACmCxouxdaIQgh6OyJM8sXQnHIaraAf4LWcXD3M/wp9BfaxLslIkV
        w8DjUhUju9pGeOR8rGppntovwWZaD60IIOK3bHRfTNLVXGoBX9Jgk36rW5j++2RgIPnONnphbgxJc
        /QYQftN1DlFCvz6G+yw4Dt4Vm/HO21hIjeKbzReIKFckOT2oCPq3c5cR26jt1j3A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mQ2N3-006k5n-V1;
        Tue, 14 Sep 2021 08:56:46 +0200
Message-ID: <7dbe6ec5b8e6b6d1e3457d075f21a7f93cc80e9c.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 5.13 01/19] dmaengine: idxd: depends on !UML
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     lkp <lkp@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Vinod Koul <vkoul@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Date:   Tue, 14 Sep 2021 08:56:44 +0200
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-09-13 at 22:33 +0000, Sasha Levin wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> [ Upstream commit b2296eeac91555bd13f774efa7ab7d4b12fb71ef ]

While this commit (and also "dmaengine: ioat: depends on !UML") isn't
*wrong* per se on old kernels, the subject matter is really only
relevant since commit 68f5d3f3b654 ("um: add PCI over virtio emulation
driver"), since previously "UML && PCI" could not be true.

Hence, there's no point applying this (and the ioat one) to anything
older than 5.14.

johannes

