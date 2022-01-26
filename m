Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C1949D35B
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 21:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiAZUWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 15:22:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54246 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiAZUWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 15:22:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 227D0B81B6E;
        Wed, 26 Jan 2022 20:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB97C340E3;
        Wed, 26 Jan 2022 20:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643228524;
        bh=WsTmQRB9nSjPKXIyrDKBXBV/01CDcV2wZlkbTor2q54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sZQnxQfRT6oRIrPaJLsyrzjKl7MbDc6MfalqgEGWeQNHZxvjBn/HDO3eIKl7Hv3Cq
         /YzIDpWAgGR8J3RjiayHHqugCvAAqKY45N9na4Dv32naFibtphEx1tKwWa7HpEoxMv
         I70sIe3qO8oytCQ0UWBTUnUGeYZI9VezoxX3kgbvJNqfcy5YfudWYpDadNpS8wvwjK
         JCQl++vPkFzCByeVsKH7KB1Eebl2zdZyVrW+cKG6lreJ3duIBVgd8ZOxav2PSiiDG7
         h9aOf3Z19DdsbVpBvd2yVsOERIb8ONpIqTqQDYcgt/zWaCDZJItOXTYyjvq74e13Zq
         AiR6NXFIq6QTw==
Date:   Wed, 26 Jan 2022 22:21:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Kleikamp <dave.kleikamp@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: trusted: Avoid calling null function
 trusted_key_exit
Message-ID: <YfGtVk/HQjgl1zSS@iki.fi>
References: <20220126184155.220814-1-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126184155.220814-1-dave.kleikamp@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 12:41:55PM -0600, Dave Kleikamp wrote:
> If one loads and unloads the trusted module, trusted_key_exit can be
> NULL. Call it through static_call_cond() to avoid a kernel trap.
> 
> Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
> 
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

Please re-send with cc stable and the empty line removed and I'll pick it.

BR, Jarkko
