Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E516271BDD
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIUHby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 03:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgIUHby (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 03:31:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9294720709;
        Mon, 21 Sep 2020 07:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600673514;
        bh=PNMuCYHCFvLasWllRE4xW+wJ2qKZOeL0wjPqVq9Lyvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENJ6KW+entjDCQ9m0p2hFlRaVx4EBkhi+s0zbWPC/kyWQpU/prpAZzkkJqMdwpkZ6
         m4U7VQICfd0XZ47/Jg+EQjIRPh9JkA3S4W8fc/NsBo921kwzEs3SF1OkK1m/3Ye6nr
         Vvtd9lnRjWNsnUL7CiU2szgkeCMADcjuiMbb5JSg=
Date:   Mon, 21 Sep 2020 09:32:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Stuart Little <achirvasub@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com,
        lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
Subject: Re: PROBLEM: 5.9.0-rc6 fails =?utf-8?Q?to_?=
 =?utf-8?Q?compile_due_to_'redefinition_of_=E2=80=98dax=5Fsupported?=
 =?utf-8?B?4oCZJw==?=
Message-ID: <20200921073218.GA3142611@kroah.com>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 11:34:17AM +0530, Naresh Kamboju wrote:
> On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
> >
> > I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz). The config file I am currently using is at
> >
> > https://termbin.com/xin7
> >
> > The build for 5.9.0-rc6 fails with the following errors:
> >
> 
> arm and mips allmodconfig build breaks due to this error.

all my local builds are breaking now too with this :(

Was there a proposed patch anywhere for this?

thanks,

greg k-h
