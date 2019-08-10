Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF888AB8
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 12:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfHJKUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 06:20:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39841 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbfHJKUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Aug 2019 06:20:47 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 465J6516RDz9sNx; Sat, 10 Aug 2019 20:20:44 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: e7de4f7b64c23e503a8c42af98d56f2a7462bd6d
In-Reply-To: <20190503075253.22798-1-ajd@linux.ibm.com>
To:     Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     stable@vger.kernel.org, Stewart Smith <stewart@linux.ibm.com>,
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH v2] powerpc/powernv: Restrict OPAL symbol map to only be readable by root
Message-Id: <465J6516RDz9sNx@ozlabs.org>
Date:   Sat, 10 Aug 2019 20:20:44 +1000 (AEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-05-03 at 07:52:53 UTC, Andrew Donnellan wrote:
> Currently the OPAL symbol map is globally readable, which seems bad as it
> contains physical addresses.
> 
> Restrict it to root.
> 
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Jordan Niethe <jniethe5@gmail.com>
> Cc: Stewart Smith <stewart@linux.ibm.com>
> Fixes: c8742f85125d ("powerpc/powernv: Expose OPAL firmware symbol map")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/e7de4f7b64c23e503a8c42af98d56f2a7462bd6d

cheers
