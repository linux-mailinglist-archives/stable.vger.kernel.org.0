Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6386D6E83B4
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 23:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjDSV1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 17:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjDSV1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 17:27:01 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8523046AE;
        Wed, 19 Apr 2023 14:26:55 -0700 (PDT)
Received: by mail.antaris-organics.com (Postfix, from userid 200)
        id 04FBC45BD4; Wed, 19 Apr 2023 23:28:06 +0200 (CEST)
Date:   Wed, 19 Apr 2023 23:22:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1681939356;
        bh=CNwHvJhep2rCN7e2S9ZMgUs0dpxJi4R9pffDoLTm29g=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=ty+x6MKThPR8IYffFHuxXMPuXzEI98Xrq9xDR6d324HQhk0APk5bsFM6PBQQAN5T9
         MGXJKHepYCgZe59he0/BI1feikX+rMRqNpw/uv6P1Gq4GqAjWOWY5GAYaL97hJhKHR
         D2Np8A8rnJFpF05xPeLF3CQj1CGILJSmNQdr05Rb2PY3tSac8HjG93gwYl4u8bMTqD
         vS6Z4HfdGjQx+yWxqQqNTOwuxaJYLjQYW9mke+BvthMzvTsfLLpu7XdYeOeIflIKi3
         P8HB+ryKP5L8gh7nL+7SF9sEKD1Q6frQ5yIc3wiS7F83FThQUxFPg0mGVtjZhWp3VN
         d6EkIo/FL56gA==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Message-ID: <20230419212235.GF3871@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230419132048.193275637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.25-rc3

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
