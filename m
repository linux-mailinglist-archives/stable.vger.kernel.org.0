Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C59191965
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgCXSsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:48:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46184 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727365AbgCXSsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:48:10 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02OIlsE5019147
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 14:47:54 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2B396420EBA; Tue, 24 Mar 2020 14:47:54 -0400 (EDT)
Date:   Tue, 24 Mar 2020 14:47:54 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ext4: Give 32bit personalities 32bit hashes
Message-ID: <20200324184754.GG53396@mit.edu>
References: <20200317113153.7945-1-linus.walleij@linaro.org>
 <CAFEAcA9mXE+gPnvM6HZ-w0+BhbpeuH=osFH-9NUzCLv=w-c7HQ@mail.gmail.com>
 <CACRpkdZtLNUwiZEMiJEoB0ojOBckyGcZeyFkR6MC69qv-ry9EA@mail.gmail.com>
 <CAFEAcA-gdwi=KSW6LqVdEJWSo9VEL5abYQs9LoHd4mKE_-h=Aw@mail.gmail.com>
 <CACRpkdYuZgZUznVxt1AHCSJa_GAXy8N0SduE5OrjDnE1s_L7Zg@mail.gmail.com>
 <20200324023431.GD53396@mit.edu>
 <CAFEAcA_6RY1XFVNJCo5=tTkv2GQpXZRqh_Zz4dYadq-8MJZgTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA_6RY1XFVNJCo5=tTkv2GQpXZRqh_Zz4dYadq-8MJZgTQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 09:29:58AM +0000, Peter Maydell wrote:
> 
> On the contrary, that would be a much better interface for QEMU.
> We always know when we're doing an open-syscall on behalf
> of the guest, and it would be trivial to make the fcntl() call then.
> That would ensure that we don't accidentally get the
> '32-bit semantics' on file descriptors QEMU opens for its own
> purposes, and wouldn't leave us open to the risk in future that
> setting the PER_LINUX32 flag for all of QEMU causes
> unexpected extra behaviour in future kernels that would be correct
> for the guest binary but wrong/broken for QEMU's own internals.

If using a flag set by fcntl is better for qemu, then by all means
let's go with that instead of using a personality flag/number.

Linus, do you have what you need to do a respin of the patch?

       	         	      	   	    	 - Ted
