Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADC76BBAB3
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjCORSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjCORSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:18:14 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08217367E0;
        Wed, 15 Mar 2023 10:18:10 -0700 (PDT)
Date:   Wed, 15 Mar 2023 18:18:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1678900689;
        bh=ORa2b1XuLXDrf+SBKTzqsb3FBzTk6RZEeR1FoYHpNFs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=YvpLXR9AO638kk5jeHIXjNa8IqYZ6+5F9K88y2gXJtEyNx5E2EweHYID53rSIbFLS
         5U59rHpS4AFwJzNRQ5tvGAiEfXZR8cIVdWQYfSLQolicG+ig2NzqnOlgpk1f8vuJxS
         Rpr4SyBoe4c3UKWjOBQOxShmXHCP2pme0/gXfkMkPzrKPfaaBug4ZByukxuLEF4KQJ
         M5VfVh5GivFK48YTHBL4F1bx5BH5Twzv9NZ/f6k/8vQnMkKEK2YM9kdqorl63D2s3H
         bAmDzBySNp4haY/lcIcbTarbim/Zl3kfGrSDuG2yrLXhyq3nSUjJ/zptWInFzTkmLh
         lERmZiVZEyoXw==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <20230315171809.GB4150@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230315115739.932786806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.7-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
