Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F6D39465B
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhE1R1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 13:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhE1R1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 13:27:20 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B61DC061574
        for <stable@vger.kernel.org>; Fri, 28 May 2021 10:25:45 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 7FB7D3F5; Fri, 28 May 2021 13:25:43 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 7FB7D3F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1622222743;
        bh=15sDvS/uIYzm1ZydlTobsnF61zSz2mBEgMIsoAOQwl8=;
        h=Date:To:Cc:Subject:From:From;
        b=yBNeskCDmqwscVafs55ra79+yJgRrCMJUr0zSjtvn41aavEcBfYY82sye1HcOeKy1
         ubikQ3wRW00yRiD0cujTjLVSMuM6W1IN7fXc7pFkt5/zcsl0We9HYyLnlImv5KiniE
         4OWAVRi8rerqlrKh7MQ5i0mtZRXZ5gJKOcceUhwo=
Date:   Fri, 28 May 2021 13:25:43 -0400
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Subject: [CI] drm/i915: Disable atomics in L3 for gen9
Message-ID: <20210528172543.GA7385@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Would it be possible to apply

	58586680ffad "drm/i915: Disable atomics in L3 for gen9"

to stable kernels?

I'm finding it quite easy to crash my Thinkpad X1 Carbon 6th gen with
Blender on Fedora 34 (which is using the 5.11.y kernels).  It applies
cleanly, and I've been running 5.11.16 with the patch applied and seeing
no obvious ill effects.

--b.
