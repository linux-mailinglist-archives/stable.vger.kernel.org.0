Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE6E1E1F2A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 11:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgEZJxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 05:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbgEZJxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 05:53:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3002073B;
        Tue, 26 May 2020 09:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590486821;
        bh=SRGf1OWFxc+QF+jDZdRaxTHUrSbBzJK36Pi2d+b4sws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOd7nV80BMFjK4oxjAasRfRZp3P2pWwsJmrQXmPAEekVh+/CBYgpfun0muHoa/TcV
         p/2YiaQVigs4BO5H8XiHPYlXOvirRMwoM7vO03aasV017OY1PrXMP7nyJnvABiRAbK
         JxmFdb2L3fS4e96vOzCWaYHkNiVM2v3lvJ7AC+Q8=
Date:   Tue, 26 May 2020 11:53:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: Build failure (riscv) in v5.4.y.queue
Message-ID: <20200526095339.GA2738150@kroah.com>
References: <80234d43-3848-45e8-6d70-1db94129e35f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80234d43-3848-45e8-6d70-1db94129e35f@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 08:29:26PM -0700, Guenter Roeck wrote:
> Build reference: v5.4.42-105-g3cb7994
> gcc version: riscv64-linux-gcc (GCC) 9.3.0
> 
> Building riscv:defconfig ... failed
> --------------
> Error log:
> arch/riscv/lib/tishift.S: Assembler messages:
> arch/riscv/lib/tishift.S:9: Error: unrecognized opcode `sym_func_start(__lshrti3)'
> arch/riscv/lib/tishift.S:29: Error: unrecognized opcode `sym_func_end(__lshrti3)'
> arch/riscv/lib/tishift.S:32: Error: unrecognized opcode `sym_func_start(__ashrti3)'
> arch/riscv/lib/tishift.S:52: Error: unrecognized opcode `sym_func_end(__ashrti3)'
> arch/riscv/lib/tishift.S:55: Error: unrecognized opcode `sym_func_start(__ashlti3)'
> arch/riscv/lib/tishift.S:75: Error: unrecognized opcode `sym_func_end(__ashlti3)'
> make[2]: *** [arch/riscv/lib/tishift.o] Error 1
> make[1]: *** [arch/riscv/lib] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [sub-make] Error 2
> --------------
> 
> Looks like 28ac255f31d7 ("riscv: Less inefficient gcc tishift helpers
> (and export their symbols)") may be missing some context commit.

Ok, will go drop this patch as it was only the kbuild systems that
seemed to want to have it added.

thanks,

greg k-h
