Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7F448D0D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfFQSzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:55:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59742 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfFQSzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 14:55:21 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hcwmi-0004Gq-Rq; Mon, 17 Jun 2019 18:55:16 +0000
Date:   Mon, 17 Jun 2019 19:55:16 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christian Brauner <christian@brauner.io>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] fs/namespace: fix unprivileged mount propagation
Message-ID: <20190617185516.GU17978@ZenIV.linux.org.uk>
References: <20190617184711.21364-1-christian@brauner.io>
 <CAHk-=wh+OWQ2s-NZC4RzfHtgNfhV9sbtP6dXV4WnsVRQ3A3hnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh+OWQ2s-NZC4RzfHtgNfhV9sbtP6dXV4WnsVRQ3A3hnA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 11:50:13AM -0700, Linus Torvalds wrote:
> On Mon, Jun 17, 2019 at 11:47 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > When propagating mounts across mount namespaces owned by different user
> > namespaces it is not possible anymore to move or umount the mount in the
> > less privileged mount namespace.
> 
> I will wait a short while in the hope of getting Al's ack for this,
> but since it looks about as good as it likely can be, I suspect I'll
> just apply it later today even without such an ack..

Give me a bit; I'm busy digging myself from under the pile of mail accumulated
in the last few weeks (bronchitis sucked, especially when it got to the point
where one can't stay asleep for more than an hour or get more than about 5 hours
per day total).  I'm trying not to throw anything relevant out, but if I don't
reply to something important today or tomorrow, please resend it my way -
the pile had been 36Kmail (down to 24K now) ;-/
