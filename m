Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C711972E69
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfGXMHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbfGXMHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 08:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3CC229ED;
        Wed, 24 Jul 2019 12:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563970019;
        bh=kY9aOXPRpGfwfHnTGTHMEdRMFdMhsa9S69gVjmKJWow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBtrG4BzS6Z9RgW7GTO0JdzEnrKf+DTJHSu+EOF/uixenCpbKa5cQTsgy/TOkUhJ7
         RiG50ad6sw7I667jQSoCKJ+HQI1ePWPBqfk/wQdls5CWSFyLnho3fNjoSWfvM8h614
         +/1zRIys1hTEJdVKmXAIOru6ULJYbs6M6+3WfQ9c=
Date:   Wed, 24 Jul 2019 14:06:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, sashal@kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?iso-8859-1?Q?Jos=E9?= Roberto de Souza 
        <jose.souza@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable v5.2] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Message-ID: <20190724120657.GG3244@kroah.com>
References: <20190719004526.B0CC521850@mail.kernel.org>
 <20190722231325.16615-1-dhinakaran.pandiyan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190722231325.16615-1-dhinakaran.pandiyan@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 04:13:25PM -0700, Dhinakaran Pandiyan wrote:
> A single 32-bit PSR2 training pattern field follows the sixteen element
> array of PSR table entries in the VBT spec. But, we incorrectly define
> this PSR2 field for each of the PSR table entries. As a result, the PSR1
> training pattern duration for any panel_type != 0 will be parsed
> incorrectly. Secondly, PSR2 training pattern durations for VBTs with bdb
> version >= 226 will also be wrong.
> 
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: José Roberto de Souza <jose.souza@intel.com>
> Cc: stable@vger.kernel.org
> Cc: stable@vger.kernel.org #v5.2
> Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field with PSR2 TP2/3 wakeup time")
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
> Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
> Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Tested-by: François Guerraz <kubrick@fgv6.net>
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190717223451.2595-1-dhinakaran.pandiyan@intel.com
> (cherry picked from commit b5ea9c9337007d6e700280c8a60b4e10d070fb53)

There is no such commit in Linus's kernel tree :(

