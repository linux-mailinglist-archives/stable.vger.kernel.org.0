Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEFE19FC1C
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 19:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgDFR4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 13:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgDFR4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 13:56:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C83120719;
        Mon,  6 Apr 2020 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586195799;
        bh=rzLQkunASwYCh4eRgQBthtCnXy2wCLIqSD4toaU61jE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZPgUFspXAjyOXk6YESQBCO1UrSAO6faqQ+/31IyDNLwAWwOzirgcwYElbC0J16W8p
         BD2LSx7iFiBWDJX47Kg1youZY7x+n4qGHh1JUV6/Try8j4iZhSz0Y4Hd4k8N/qo63A
         UixX/Y/vII3JSSnASaPKdgcXoT/HzebDuOGYmv6g=
Date:   Mon, 6 Apr 2020 19:56:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Dirk Mueller <dmueller@suse.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>, k.opasiak@samsung.com,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        kopasiak90@gmail.com, Sasha Levin <sashal@kernel.org>
Subject: Re: [linux-stable-rc:linux-4.4.y 9959/9999]
 drivers/usb/gadget/function/f_uac2.c:601:40: warning: variable
 'devqual_desc' is not needed and will not be emitted
Message-ID: <20200406175635.GA167424@kroah.com>
References: <202004050547.XbHnZtwa%lkp@intel.com>
 <20200404213110.GA34553@ubuntu-m2-xlarge-x86>
 <CAKwvOdnPOVfi35Vrxr1+FsPN+V2X5UiwxTdOu+pdwsBAGXxb5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnPOVfi35Vrxr1+FsPN+V2X5UiwxTdOu+pdwsBAGXxb5g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 10:37:20AM -0700, Nick Desaulniers wrote:
> On Sat, Apr 4, 2020 at 2:31 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Sun, Apr 05, 2020 at 05:23:53AM +0800, kbuild test robot wrote:
> > > Hi Dirk,
> > >
> > > First bad commit (maybe != root cause):
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > > head:   1d2188f191be66572f9e20c9486eda0544ab750f
> > > commit: ce513359d8507123e63f34b56e67ad558074be22 [9959/9999] scripts/dtc: Remove redundant YYLOC global declaration
> > > config: x86_64-allmodconfig (attached as .config)
> > > compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 62f3a9650a9f289a07a5f480764fb655178c2334)
> > > reproduce:
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         git checkout ce513359d8507123e63f34b56e67ad558074be22
> > >         # save the attached .config to linux build tree
> > >         COMPILER=clang make.cross ARCH=x86_64
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > > >> drivers/usb/gadget/function/f_uac2.c:601:40: warning: variable 'devqual_desc' is not needed and will not be emitted [-Wunneeded-internal-declaration]
> > >    static struct usb_qualifier_descriptor devqual_desc = {
> > >                                           ^
> > >    1 warning generated.
> > > --
> > > >> drivers/usb/gadget/function/f_printer.c:164:40: warning: variable 'dev_qualifier' is not needed and will not be emitted [-Wunneeded-internal-declaration]
> > >    static struct usb_qualifier_descriptor dev_qualifier = {
> > >                                           ^
> > >    1 warning generated.
> > >
> >
> > Not caused by that patch.
> >
> > Fixed in mainline:
> 
> Hmm...no fixes tag, probably should still be backported to stable.
> 
> >
> > https://git.kernel.org/linus/d4529f9be1d72919f75f76f31773c4e98d03ce6b
> > https://git.kernel.org/linus/e5a89162161d498170e7e39e6cfd2f71458c2b00

Fine, now done...
