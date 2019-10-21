Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3364DE28C
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 05:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJUDes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Oct 2019 23:34:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfJUDer (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Oct 2019 23:34:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3FD92602F3; Mon, 21 Oct 2019 03:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571628887;
        bh=fI7tTnZ9WhKA6PLwrHG4qATFBHcajJ5p+pnrXJfRTag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hG5mgXE6cUFDxekZFIruNrN7BRBh68GopMGYkdyEr8mCo6gx9zOORNWcmNCS9KuvF
         clIWEvsjA0mWxz9/kzGZBb1pmLPN1xaCs9PbdTgBJWp5xgM563dixnSUmDE+xM0q79
         LdpJdWIJwmW+mY0sCtzNMSPj/VRswBACxcTkjg0A=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B038E6030D;
        Mon, 21 Oct 2019 03:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571628886;
        bh=fI7tTnZ9WhKA6PLwrHG4qATFBHcajJ5p+pnrXJfRTag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWcoC3UUUfb1pJYIb6nwXlPxdc8u412Q8OmUxlkZRVMyxP3E1CX8xMg/Hf8iZlkd+
         ATJIBC8mXtB4R1FBq15H35/j+bzYui9p1F0z3/9GfiM2cuyjRgAWl3tZPfBLJcGoDf
         n2RWz7C9PnNbfI6SJTSA5mR/YQ0Y6E96M0HUGVRM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 20 Oct 2019 20:34:46 -0700
From:   cgoldswo@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: reserved_mem: add missing of_node_put() for proper
 ref-counting
In-Reply-To: <20191021020624.GE4500@tuxbook-pro>
References: <1571536644-13840-1-git-send-email-cgoldswo@codeaurora.org>
 <20191021020624.GE4500@tuxbook-pro>
Message-ID: <7c57d99e9240e1e7198b835a35089cf5@codeaurora.org>
X-Sender: cgoldswo@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On 2019-10-20 19:06, Bjorn Andersson wrote:
> Cc stable@ is used to assist in making sure your patch is backported to
> stable kernels, other than that the purpose Cc here is to indicate that
> specific people have been requested to comment on your patch.
> 
> So please skip these from the commit message in the future

Thanks for informing me of this, I've re-read the patch submission
documentation and will omit the Cc's in the future from the commit
message (other than Cc stable@).

Regards,

Chris.
