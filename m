Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB207C04A
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 13:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGaLnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 07:43:24 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40655 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGaLnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 07:43:24 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45zBQ14ftsz9s00;
        Wed, 31 Jul 2019 21:43:21 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Jordan Niethe <jniethe5@gmail.com>,
        Stewart Smith <stewart@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/powernv: Restrict OPAL symbol map to only be readable by root
In-Reply-To: <2a934abd-07c0-2741-8f2e-b9224abde005@linux.ibm.com>
References: <20190503075253.22798-1-ajd@linux.ibm.com> <2a934abd-07c0-2741-8f2e-b9224abde005@linux.ibm.com>
Date:   Wed, 31 Jul 2019 21:43:21 +1000
Message-ID: <87h872qvja.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew Donnellan <ajd@linux.ibm.com> writes:
> On 3/5/19 5:52 pm, Andrew Donnellan wrote:
>> Currently the OPAL symbol map is globally readable, which seems bad as it
>> contains physical addresses.
>> 
>> Restrict it to root.
>> 
>> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Jordan Niethe <jniethe5@gmail.com>
>> Cc: Stewart Smith <stewart@linux.ibm.com>
>> Fixes: c8742f85125d ("powerpc/powernv: Expose OPAL firmware symbol map")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
>
> mpe: ping?

Picked up for v5.4.

cheers
