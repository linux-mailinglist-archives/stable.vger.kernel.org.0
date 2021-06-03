Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B02C39A38D
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 16:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhFCOop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 10:44:45 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51155 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231594AbhFCOop (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 10:44:45 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 153EgnfG008612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Jun 2021 10:42:50 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id AC16D15C3CAF; Thu,  3 Jun 2021 10:42:49 -0400 (EDT)
Date:   Thu, 3 Jun 2021 10:42:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Correct encrypted_casefolding sysfs entry
Message-ID: <YLjqaRHlGG1Err80@mit.edu>
References: <20210603094849.314342-1-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603094849.314342-1-drosen@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 09:48:49AM +0000, Daniel Rosenberg wrote:
> Encrypted casefolding is only supported when both encryption and
> casefolding are both enabled in the config.
> 
> Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> Cc: stable@vger.kernel.org # 5.13+
> Signed-off-by: Daniel Rosenberg <drosen@google.com>

Thanks, applied.

					- Ted
