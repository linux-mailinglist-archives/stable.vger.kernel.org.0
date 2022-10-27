Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F91C60F4C1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbiJ0KT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiJ0KT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:19:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A5F03F;
        Thu, 27 Oct 2022 03:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C92C6CE25C3;
        Thu, 27 Oct 2022 10:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821EAC433C1;
        Thu, 27 Oct 2022 10:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666865991;
        bh=NqMrmdJW4/CFJyAsbuJvEyN1j+Q4SJytBhbMA3wApjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=onYFzYorCHVobqFga8odCiCw3zhyp2dljGm5m00ISE9Ji1zG1HZbyuE8FIZ5MPmq2
         FI4hP9uT9L82dsUXFtdYxpJbuGtVgTWYmuID+/8DL32wJOSmtFg3D9jylLtvz+jEF5
         rekz017okoXEAjA2vyv7p9c6XiBmC8HbgOiH93NI=
Date:   Thu, 27 Oct 2022 12:19:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     stable@vger.kernel.org, Brice.Goglin@inria.fr,
        atishp@atishpatra.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        sudeep.holla@arm.com, will@kernel.org,
        Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH 5.10 1/2] arm64: topology: move store_cpu_topology() to
 shared code
Message-ID: <Y1pbRCQbgMw8Upvz@kroah.com>
References: <20221019125303.2845522-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019125303.2845522-1-conor.dooley@microchip.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 01:53:02PM +0100, Conor Dooley wrote:
> commit 456797da792fa7cbf6698febf275fe9b36691f78 upstream.

All now queued up, thanks.

greg k-h
