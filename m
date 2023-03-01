Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEBF6A68F1
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 09:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjCAIb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 03:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAIb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 03:31:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA31338EAE;
        Wed,  1 Mar 2023 00:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ADD6B80FE3;
        Wed,  1 Mar 2023 08:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA7C433D2;
        Wed,  1 Mar 2023 08:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677659484;
        bh=7ZDi1xYSyekJUy3ZFk60GlpMPr/ZrXKjag6LEW/h750=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dcJ9pW8KueEC4Tzw6uGCERbS9yvImtKNtw1S2vLfD7insx6HP0jqi19xJnOu0PoSp
         46zYOcltGL14nCAOZPioApJxcb6tqI4wENQeFy9eKvcyVUCLYFnNGUSeK2+y6dLY1L
         b+j3ZUyt6sBbJWzCumWQsP32ajpcCE5VXgn6lBy0CTK8FlGk0l3Vdokc4JJ+HkEVYo
         CH8vPCLoEsvKmfuCL2ARUym2rCI20fsWtAJGv48gxJAQgLO2YpcuiBsOGbCCnhM5lP
         DjyfYckgE+GhenvBReN54tVlN60ksd7s1yoIyYz38h6YPxXpVOUHbF30zx+tCMLpw7
         IiD6otQjcywXQ==
Date:   Wed, 1 Mar 2023 00:31:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Slade Watkins <srw@sladewatkins.net>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/8NWuHX0Sff+DhY@sol.localdomain>
References: <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
 <Y/7fFHv3dU6osd6x@sol.localdomain>
 <Y/7sLcCtsk9oqZH0@kroah.com>
 <Y/79Tfn5kFIItUDD@sol.localdomain>
 <Y/8BU4cyySwQZSII@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/8BU4cyySwQZSII@1wt.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 08:40:03AM +0100, Willy Tarreau wrote:
> But it's going into a dead end. You are the one saying that changes
> are easy, suggesting to use get_maintainers.pl, so easy that you can't
> try to adapt them in existing stuff. Even without modifying existing
> scripts, if you are really interested by such features, why not at least
> try to run your idea over a whole series, figure how long it takes, how
> accurate it seems to be, adjust the output to remove unwanted noise and
> propose for review a few lines that seem to do the job for you ?
> 

As I said, Sasha *already does this for AUTOSEL*.  So it seems this problem has
already been solved, but Sasha and Greg are not coordinating with each other.

Anyway, it's hard to have much motivation to try to contribute to scripts that
not only can I not use or test myself, but before even getting to that point,
pretty much any ideas for improvements are strongly pushed back on.  Earlier I
was actually going to go into more detail about some ideas for how to flag and
review potential problems with backporting a commit, but I figured why bother
given how this thread has been going.

(Also I presume anything that would add *any* human time on the stable
maintainers' end per patch, on average, would be strongly pushed back on too?
But I have no visibility into what would be acceptable.  I don't do their job.)

- Eric
