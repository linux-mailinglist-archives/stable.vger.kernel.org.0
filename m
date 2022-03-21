Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91FE4E2474
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 11:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346400AbiCUKhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 06:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346398AbiCUKhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 06:37:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F63A141FF7
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 03:35:58 -0700 (PDT)
Date:   Mon, 21 Mar 2022 11:35:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647858956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wlvgSckj83sVwM2myjSngn30vT+stmNE9cDaVdfypuU=;
        b=YQOXCzc6Og3plfnHm3mEH0pJ3Z9WHcAqsZne2htzZDiorZPL7T+Q+8+jr9JsgDBQNiOBVX
        9aeBS3e2KT1ZOJIwofq7ik6iEQCcO1dWFzFXUbFDBM6wicAGTzJPqC5TbF4tMcWssheOfz
        aF46bv9F8MFGoCPn9yuzXBvxo8UephQ42eZH17kZuuiBOf//OcJlxlyC9rOpN4pprmL4SB
        ytRT8ArczyX1Kn+of72sIFgxB75UXHpsoDNr6GLdg3ZCLh3/a9fXeMH3OTzY9CJhfhAkrj
        pcJmI1Vc1IVvhP9E6PZNOokTlyiLT+cz1tBUYhEuiPJoCRbAk94xNRQELnDSlw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647858956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wlvgSckj83sVwM2myjSngn30vT+stmNE9cDaVdfypuU=;
        b=baCFcbQKINQtZq/+rEE0X0pY20d9Pw6/qWOaJSlCJ1spVrwA8NDQ6dGRCPWy0hH5Jw23Jl
        5ztBRKcIiWUzrPDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: The linux-5.17.y tag looks bogus.
Message-ID: <YjhVC7yYQRzhyqoe@linutronix.de>
References: <YjhPvcJ9opIrx+ua@linutronix.de>
 <YjhQuSYxLBVc+kJC@kroah.com>
 <YjhR+FI3CWeZ3Db0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YjhR+FI3CWeZ3Db0@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-21 11:22:48 [+0100], Greg KH wrote:
> Ah, I see that now.  That's odd.  I've deleted it, I don't know how that
> got created, maybe our scripts messed up.  Something went "odd" on the
> release that git.kernel.org told me about, but I have to wait until some
> people wake up in the Americas before I can figure out what actually
> happened.

Thank you.

> thanks,
> 
> greg k-h

Sebastian
