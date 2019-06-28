Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8FC59DB1
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfF1O0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 10:26:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42643 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbfF1O0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 10:26:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D88B321448;
        Fri, 28 Jun 2019 10:26:28 -0400 (EDT)
Received: from imap5 ([10.202.2.55])
  by compute1.internal (MEProxy); Fri, 28 Jun 2019 10:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=mime-version:message-id:in-reply-to:references:date:from:to
        :cc:subject:content-type; s=fm1; bh=Ow1/fltrpvTqI++jLPkstJ3FxDDY
        PwyEP957qyWFDh4=; b=UVDpVvs6GLi5e0VoR1u7gIaFmvwgLSrs0G2GqR4/WVMO
        NshtNHpG+yIXHfo3yjEFzYxAdVqeQ5g6ku39Zif/rAfcShsA35GuhsgJD2yk3vxs
        1/Eqk00nBDhNVHOX0l6vYo2W/+zr3tV7wvgbPFM9+eKxtvhP58RBJvEoAwMRYgZn
        g0LXuOxFAs5Q8cNzHnfQKNsfqT4V4K2R4sMVO8sXG9AJ3ol/QK55a3XiHX6tNNPz
        +5eeHOWoTWugBRlF3df00t49YzQC4XcKzVxRcWgtkhGdkDb2av6Wa03jXbmgxBqm
        uAgSDnEVp8L0fC1DTBUCYbKLKtBT8UOzsINwNPiMkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ow1/fl
        trpvTqI++jLPkstJ3FxDDYPwyEP957qyWFDh4=; b=FbjhzHQGm6hoB9SIy1e61A
        XbsRZNCWnhK9M+IAICxy7g0oNearM1k/rVdqo3+9qQmhrpSVUBkjAo2BD2STPrFR
        xkZIhzKfY52W+A9LstCbEX7dZjgFrmjBADOKgioY6PUIJVICoWkGjCMmpzbh5ilL
        VtxqnL1JW+pWlk4ea9RXyDigLw3HjTutfco28/U6s5xXa/LRfxqtlGC57W4Rkatj
        54ssf5qIuA1BBkzyfb3QSpMe1PsBlUohxHjWR6SLUZkh6tUaUFrmntP88cUqLRGM
        WmGQUqvidbQxVuY7fJv+A4vnk6G1kSh9bST5LFiBNWJ0dd6c6sljaUtiw7z1LGQg
        ==
X-ME-Sender: <xms:kyMWXdh8U_bbD7064HIGVUWpDK5_COuDUgBdS7_MJE-rojCpplSAxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvddtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedfvfgrkhgr
    shhhihcuufgrkhgrmhhothhofdcuoehoqdhtrghkrghshhhisehsrghkrghmohgttghhih
    drjhhpqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehoqdhtrghkrghshhhisehsrghkrghmohgttghhihdrjhhpnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:kyMWXSLx7YpI5GBplDRlydoIxYhekV_6wvdJsKBDJSMHaWwsxHfhBw>
    <xmx:kyMWXdVE7wHWaHlRkVQI9Z4HrgDae5PW2d4M_vlvFnWEn2vj63Bk4A>
    <xmx:kyMWXWVEdXiuTHgeRApz_UFeq9Vqwkc7YlGVlbq5WkdARX2yiWrS5w>
    <xmx:lCMWXX-lAHoiMharWCJ6Qkp9yJzBs84_lvq1FMGLXpZpTAiX7oVW1A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2E89B5C009B; Fri, 28 Jun 2019 10:26:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.6-731-g19d3b16-fmstable-20190627v1
Mime-Version: 1.0
Message-Id: <bd65234a-9963-4e25-938f-1e79b053c4e1@www.fastmail.com>
In-Reply-To: <s5ho92i6qhi.wl-tiwai@suse.de>
References: <20190628052158.27693-1-o-takashi@sakamocchi.jp>
 <s5ho92i6qhi.wl-tiwai@suse.de>
Date:   Fri, 28 Jun 2019 16:34:00 +0900
From:   "Takashi Sakamoto" <o-takashi@sakamocchi.jp>
To:     "Takashi Iwai" <tiwai@suse.de>
Cc:     "Clemens Ladisch" <clemens@ladisch.de>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: =?UTF-8?Q?Re:_[PATCH]_ALSA:_firewire-lib/fireworks:_fix_miss_detection_o?=
 =?UTF-8?Q?f_received_MIDI_messages?=
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Jun 28, 2019, at 17:53, Takashi Iwai wrote:
> On Fri, 28 Jun 2019 07:21:58 +0200,
> Takashi Sakamoto wrote:
> > 
> > In IEC 61883-6, 8 MIDI data streams are multiplexed into single
> > MIDI conformant data channel. The index of stream is calculated by
> > modulo 8 of the value of data block counter.
> > 
> > In fireworks, the value of data block counter in CIP header has a quirk
> > with firmware version v5.0.0, v5.7.3 and v5.8.0. This brings ALSA
> > IEC 61883-1/6 packet streaming engine to miss detection of MIDI
> > messages.
> > 
> > This commit fixes the miss detection to modify the value of data block
> > counter for the modulo calculation.
> > 
> > For maintainers, this bug exists since a commit 18f5ed365d3f ("ALSA:
> > fireworks/firewire-lib: add support for recent firmware quirk") in Linux
> > kernel v4.2. There're many changes since the commit.  This fix can be
> > backported to Linux kernel v4.4 or later. I tagged a base commit to the
> > backport for your convenience.
> > 
> > Fixes: df075feefbd3 ("ALSA: firewire-lib: complete AM824 data block processing layer")
> > Cc: <stable@vger.kernel.org> # v4.4+
> > Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> 
> This doesn't seem applicable to the latest 5.2-rc tree due to your
> recent refactoring.  Could you resubmit the fix for 5.2?  I'll resolve
> the merge conflict in my side.

Mmm. Do you actually encounter any conflict when applying this patch to
your v5.2 tree?

This patch includes changes for `sound/firewire/amdtp-am824.c`. On the other
hand, my recent work is mainly for `sound/firewire/amdtp-stream.c`. Actually,
the last change for `amdtp-am824.c` was done 2017-10-25.
https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git/log/sound/firewire/amdtp-am824.c?h=for-linus


Thanks


Takashi Sakamoto
