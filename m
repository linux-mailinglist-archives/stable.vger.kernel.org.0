Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F881F495B
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 00:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgFIW0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 18:26:10 -0400
Received: from fsfla.org ([217.69.89.142]:56580 "EHLO fsfla.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgFIW0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 18:26:10 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2020 18:26:09 EDT
Received: from free.home (179.178.72.90.dynamic.adsl.gvt.net.br [179.178.72.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fsfla.org (Postfix) with ESMTPSA id 33F39A275E;
        Tue,  9 Jun 2020 22:18:26 +0000 (UTC)
Received: from livre.home (livre.home [172.31.160.2])
        by free.home (8.15.2/8.15.2) with ESMTPS id 059MI6tu910930
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 9 Jun 2020 19:18:06 -0300
From:   Alexandre Oliva <lxoliva@fsfla.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Include asm sources for {ivb, hsw}_clear_kernel.c
Organization: Free thinker, not speaking for FSF Latin America
References: <20200608174654.1400710-1-rodrigo.vivi@intel.com>
        <159163988890.30073.8976615673203599761@build.alporthouse.com>
Date:   Tue, 09 Jun 2020 19:18:06 -0300
In-Reply-To: <159163988890.30073.8976615673203599761@build.alporthouse.com>
        (Chris Wilson's message of "Mon, 08 Jun 2020 19:11:28 +0100")
Message-ID: <ortuzjx4rl.fsf@livre.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Jun  8, 2020, Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Quoting Rodrigo Vivi (2020-06-08 18:46:53)
>> Alexandre Oliva has recently removed these files from Linux Libre
>> with concerns that the sources weren't available.
>> 
>> The sources are available on IGT repository, and only open source
>> tools are used to generate the {ivb,hsw}_clear_kernel.c files.
>> 
>> However, the remaining concern from Alexandre Oliva was around
>> GPL license and the source not been present when distributing
>> the code.

Thanks for looking into this, and for addressing the potential issues so
promptly.

>> let's make sure that we do include the asm sources here in our tree.

+1  having sources handy is good!

>> Btw, I tried to have some diligence here and make sure that the
>> asms that these commits are adding are truly the source for
>> the mentioned files:

Excellent!

> Should there not be instructions on how to generate the object code?

Considering that a script is used to generate it, to the point of adding
some of the comments in the output, it might be a good idea to include
it too, especially considering that scripts that control compilation are
part of the complete corresponding source code under the GNU GPL.


IMHO, a link to help users locate the assembler, as comments in the
script, would be welcome, though not mandatory IIUC.  Even though such
links tend to rot over time, they at least offer encouragement to start
or carry on a search ;-)


Thanks again,

-- 
Alexandre Oliva, freedom fighter    he/him    https://FSFLA.org/blogs/lxo/
Free Software Evangelist              Stallman was right, but he's left :(
GNU Toolchain Engineer           Live long and free, and prosper ethically
