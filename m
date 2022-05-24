Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A17532849
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 12:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbiEXKyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 06:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiEXKyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 06:54:01 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665F4579BD;
        Tue, 24 May 2022 03:53:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6rfX1zQrz4xbt;
        Tue, 24 May 2022 20:53:56 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20220506070747.16309-1-bagasdotme@gmail.com>
References: <20220506070747.16309-1-bagasdotme@gmail.com>
Subject: Re: [PATCH RESEND] KVM: powerpc: remove extraneous asterisk from rm_host_ipi_action comment
Message-Id: <165338950668.1711920.11760808136343682711.b4-ty@ellerman.id.au>
Date:   Tue, 24 May 2022 20:51:46 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 6 May 2022 14:07:47 +0700, Bagas Sanjaya wrote:
> kernel test robot reported kernel-doc warning for rm_host_ipi_action():
> 
> >> arch/powerpc/kvm/book3s_hv_rm_xics.c:887: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Host Operations poked by RM KVM
> 
> Since the function is static, remove the extraneous (second) asterisk at
> the head of function comment.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: powerpc: remove extraneous asterisk from rm_host_ipi_action comment
      https://git.kernel.org/powerpc/c/d53c36e6c83863fde4a2748411c31bc4853a0936

cheers
