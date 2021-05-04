Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01C372BCE
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhEDORE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 10:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231308AbhEDORE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 10:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F707610FA;
        Tue,  4 May 2021 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620137769;
        bh=uz5a7cJ2r811UV8pCUnNKyfngvW9/TTCZFmVaI8xWgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RcUK8zv4N5G/K8//HefJV8YPH8EweoqGi8nq9guawOn7AOxuNfmPVgVVsptQwDiEG
         hDGoKwbKvJCFrXANtKnhkbCN9etIGIAn2QIqlvqrn3GNsXpj02TndXEQrhuZRBOA4l
         EgbE0w1lPkWnKCHN8GX/xlr/PQ6kIcg+GN9cvW10=
Date:   Tue, 4 May 2021 16:16:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable:linux-5.4.y 5541/6083] ERROR: "__memcat_p"
 [drivers/hwtracing/stm/stm_core.ko] undefined!
Message-ID: <YJFXJyoiWo6ArrNT@kroah.com>
References: <202105030311.xWwkyV9z-lkp@intel.com>
 <CAK8P3a0ZdZY94KVwF-C_t+7rx=iHC60ty52AQAmc1VDZwsn9Rw@mail.gmail.com>
 <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
 <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
 <YJDQ0ePGHxmcB7dX@kroah.com>
 <CAK8P3a30xJ1+zrCC4fk+q9xzLspHuE4VM0UHSWiU3-iFeNN+6g@mail.gmail.com>
 <YJEFF1iHZ4o7LUgV@kroah.com>
 <CAK8P3a2-ttarw-31YTbq1YbwAxvG3HwouKC9u1YjfyQwMhwovw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2-ttarw-31YTbq1YbwAxvG3HwouKC9u1YjfyQwMhwovw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 12:46:05PM +0200, Arnd Bergmann wrote:
> On Tue, May 4, 2021 at 10:26 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, May 04, 2021 at 09:41:14AM +0200, Arnd Bergmann wrote:
> > > which is the same as what 7273ad2b08f8 does, but only for this one file
> > > instead of all of lib/*.o.
> >
> > I think a "one off" change would be best here.  Can you submit it?
> 
> Sent https://lore.kernel.org/lkml/20210504104441.1317138-1-arnd@kernel.org/T/

Thanks, now queued up.

greg k-h
