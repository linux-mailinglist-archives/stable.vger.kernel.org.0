Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C3F489DC3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbiAJQnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 11:43:23 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:54269 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiAJQnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 11:43:22 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 152262800B3C7;
        Mon, 10 Jan 2022 17:43:21 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id EBEB955BEF; Mon, 10 Jan 2022 17:43:20 +0100 (CET)
Date:   Mon, 10 Jan 2022 17:43:20 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        Len Brown <lenb@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "Chen, Guchun" <Guchun.Chen@amd.com>,
        "Grodzovsky, Andrey" <Andrey.Grodzovsky@amd.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when
 calling hw_fini (v2)"
Message-ID: <20220110164320.GA21246@wunner.de>
References: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
 <BL1PR12MB514403767AC6BC6CD617674DF7509@BL1PR12MB5144.namprd12.prod.outlook.com>
 <2e3fbfe8-e7a1-2483-dbbd-ebb3824fc886@amd.com>
 <BL1PR12MB51441B895F9846A11D6268E2F7509@BL1PR12MB5144.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51441B895F9846A11D6268E2F7509@BL1PR12MB5144.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 04:25:51PM +0000, Deucher, Alexander wrote:
> Thanks.  I'll wait for feedback from Guchun and Andrey and if they are
> ok with it, I'll apply the revert.

Linus already picked it up yesterday, it's in v5.16.
