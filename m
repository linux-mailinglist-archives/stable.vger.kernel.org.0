Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D79132F7E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 20:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgAGTa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 14:30:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35054 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 14:30:57 -0500
Received: from ip-109-41-1-29.web.vodafone.de ([109.41.1.29] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iouZ2-0004Mw-9L; Tue, 07 Jan 2020 19:30:52 +0000
Date:   Tue, 7 Jan 2020 20:30:54 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Will Deacon <will@kernel.org>,
        Amanieu d'Antras <amanieu@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/7] arm64: Implement copy_thread_tls
Message-ID: <20200107193054.t2d4txgz3fnrw3gn@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-3-amanieu@gmail.com>
 <20200102180130.hmpipoiiu3zsl2d6@wittgenstein>
 <20200106173953.GB9676@willie-the-truck>
 <CA+y5pbSBYLvZ46nJP0pSYZnRohtPxHitOHPEaLXq23-QrPKk2g@mail.gmail.com>
 <20200107090219.jl4py4u2zvofwnbh@wittgenstein>
 <20200107174508.GC32009@willie-the-truck>
 <202001071011.9517D9C0D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202001071011.9517D9C0D@keescook>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 10:12:39AM -0800, Kees Cook wrote:
> On Tue, Jan 07, 2020 at 05:45:09PM +0000, Will Deacon wrote:
> > On Tue, Jan 07, 2020 at 10:02:27AM +0100, Christian Brauner wrote:
> > > [Cc Kees in case he knows something about where arch specific tests live
> > >  or whether we have a framework for this]
> > > [...]
> > > It feels like we must've run into the "this is architecture
> > > specific"-and-we-want-to-test-this issue before... Do we have a place
> > > where architecture specific selftests live?
> > 
> > For arch-specific selftests there are tools/testing/selftests/$ARCH
> > directories, although in this case maybe it's better to have an #ifdef
> > in a header so that architectures with __builtin_thread_pointer can use
> > that.
> 
> Yup, I agree: that's the current best-practice for arch-specific
> selftests.

Thanks! I think using #ifdef in this case with __builtin_thread_pointer
sounds good.
So the tests can be moved into the clone3() test-suite for those
architectures.

Christian
