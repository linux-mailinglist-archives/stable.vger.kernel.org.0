Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57455F7E45
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 21:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJGToj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 15:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJGToj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 15:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19AB260C
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 12:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA8A61DB4
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 19:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FC3C433D6;
        Fri,  7 Oct 2022 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665171876;
        bh=QmBYX/ynzdcCQqcp01BZdi65XO9VSXqeo88XcqTzq1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xu02AJSZ3KcynhKe8Oj2yjNK0UALyzkvgHOFVlCL9Hw3tUFv48LmwIJ/KOB1s0I4d
         4VDxMKDo9WFjdCvjRiBZY8emvjvFTH3CElKoVZLh7Eg+pJHWeHAzZYjaZ0Rl89BDrX
         UaKqiGVxPL+eSR+VMu37VwvrE5tcRSSJVR5iAEts=
Date:   Fri, 7 Oct 2022 21:45:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH] compiler_attributes.h: move __compiletime_{error|warning}
Message-ID: <Y0CBzgaKnW7SYzem@kroah.com>
References: <20221007193436.906-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007193436.906-1-bvanassche@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 12:34:36PM -0700, Bart Van Assche wrote:
> From: Nick Desaulniers <ndesaulniers@google.com>
> 
> commit b83a908498d68fafca931e1276e145b339cac5fb upstream.

This is already in 5.15, what stable kernel tree(s) is this a backport
for?

thanks,

greg k-h
