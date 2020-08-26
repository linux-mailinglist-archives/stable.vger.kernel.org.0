Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1819D252D2A
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgHZL6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgHZL6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 07:58:21 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1ACC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 04:58:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bc4BH2Qjqz9sTR;
        Wed, 26 Aug 2020 21:58:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1598443095;
        bh=MS+f0WHAHjfA6EqlylHw2U6qlVWZcTPnytdwjdmqqxo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WD366TFsG57J4YACK+ntB2t5tojZxsOSqUkCyu07896wqTOVYQ547sM8UmbagPOKM
         XzzLh5dbTmbQ+t++gRDzZpqdwA+u4zj7ZCbbx55t4Q514kgNpKKx249AIDe7/X0Ytv
         M2Rh9JyTqzfL+1snjI5sTN5Zk2suha2v6Z/Bq54/6tFDxQQyU8U4mASciteDL5h6da
         70/fBJoMRNzLO667ShF9IQWrDbPwe0O8XVmDwJchJKo1YNXxC/PM3XVBqjcv13sQwG
         WgZ8rJ6qagEOt999C8qf+2LU3CY3isJzxf6AYXI00kkxGk5IzjJ7Z6RFGp+v9k5riY
         3RqrjQRfC9TaQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        sashal@kernel.org
Subject: Re: Please apply commit 0828137e8f16 ("powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()") to v4.14.y, v4.19.y, v5.4.y, v5.7.y
In-Reply-To: <20200826102929.GA3356257@kroah.com>
References: <20200825224408.GB6060@mussarela> <20200826102929.GA3356257@kroah.com>
Date:   Wed, 26 Aug 2020 21:58:11 +1000
Message-ID: <87o8mxhb58.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Tue, Aug 25, 2020 at 07:44:08PM -0300, Thadeu Lima de Souza Cascardo wrote:
>> After commit 912c0a7f2b5daa3cbb2bc10f303981e493de73bd ("powerpc/64s: Save FSCR
>> to init_task.thread.fscr after feature init"), which has been applied to the
>> referred branches, when userspace sets the user DSCR MSR, it won't be inherited
>> or restored during context switch, because the facility unavailable interrupt
>> won't trigger.
>> 
>> Applying 0828137e8f16721842468e33df0460044a0c588b ("powerpc/64s: Don't init
>> FSCR_DSCR in __init_FSCR()") will fix it.

Oops, thanks for catching it.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>


> Now queued up, thanks.

Thanks.

cheers
