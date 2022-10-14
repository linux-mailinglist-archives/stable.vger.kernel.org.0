Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0530C5FF24A
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJNQes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 12:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiJNQer (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 12:34:47 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD3C13E16;
        Fri, 14 Oct 2022 09:34:45 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6002C5801C4;
        Fri, 14 Oct 2022 12:34:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 14 Oct 2022 12:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1665765284; x=1665768884; bh=eePP4VOEf5
        cdPc/4cOOLyLDuRpg/KHxOefM+qUoulcA=; b=VMEr1Hg5mpsrGJgHe06UCyCHGI
        mLeNizyzEwWBGT8hnGNRaZfs/d7kxjFZ8iU08McUTCf07Eb1E5TbOj/+CoJfpjYI
        D2XXSW9gZYgk1gypQPOcUi/hqwiFNPIt+BaSO/TDQE0BFXjjRynkSDx3DPuphPhZ
        ebqdgV+D5or1NjBVYS+GGHf7Ina38O0iHhjvjIy7eClweQa+KtGEBlyMe3eMEYag
        vBwb4QdheP7whxhPpND3rnB9NvNLnivC0ej/VYUD8l5I6U7ReWIGtXmtL5ToTUTu
        OoBzr4JF/Etcc6uSpk6Oz0ZOkBf/F7NOciFhoIVgze6aWPbL3/nNGfprZrOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665765284; x=1665768884; bh=eePP4VOEf5cdPc/4cOOLyLDuRpg/
        KHxOefM+qUoulcA=; b=HJOA1zXVT/mXqKVKgM+aCa6Y+PqdqOIbpkH9JMMFW6rZ
        dItznxyXMZX9MRxyrJvwIJ1hcDgcV5gJpWYMa1z93cbtUG+Bsq/xHo7SxkcONFq9
        RDozb6AeynSCIbTH0yhqpoiqW0TZmzawmB3zeKj49DjaxUk/XBHHlYpIGch0qRvT
        0HRtDllkPAp5Rs1XdWbv8iUKIjtHEZiV+wK5IJQ3mYRn+5aumfceRccmj9JbUh3p
        76TlLvlO4P2/ngFpYp0sRJRH6ZqYH3MddNKSBWPyP4LQa2I7kdaxtg6MVMqvAPKD
        bDQ72L+DHhuAu8MF9TRT2Ov5OF/suB83TnPczxIgSw==
X-ME-Sender: <xms:pI9JY2Lrql0-7v43QRA70NIFfFwq-NW7OV3_0t8VLRD7bgp0Exnbzw>
    <xme:pI9JY-JgjrO6kUc4zeiEMWE7gXUb772Ei9HoDC-CoMHuDMGX-fh6ik6peC_nW8SxL
    SnGssRitWPP__6QioU>
X-ME-Received: <xmr:pI9JY2ukYqLbxK0pKjRp1UF4L4mRs9DkV_qdTqoJ2BdjXQsxyxlc4TRFqpY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefvhihl
    vghrucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtth
    gvrhhnpefggeekieffteehgfetffduhfefjeehvdejhfejkeduleffudelhfefkeeiledu
    jeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheptghouggvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:pI9JY7aPP2XYN-CS7wu8H7MyqEpok89EK2f7R4XZafIVlsCi5KLVww>
    <xmx:pI9JY9Z4OcNddSFtvV3lrUAqPdmZYfEogjZ5oxy3uuwgibt8_MQsuw>
    <xmx:pI9JY3BTNzyEc8Chatzhw45--YuL9BndecoLPiU-sPGFwsKhy48KCA>
    <xmx:pI9JY57nuUw03LouCCII_5Yq8HpUW8XlzHdCHCY82XrW53PUAMRhSA>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Oct 2022 12:34:43 -0400 (EDT)
Date:   Fri, 14 Oct 2022 11:34:26 -0500
From:   Tyler Hicks <code@tyhicks.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Documentation: process: update the list of current LTS
Message-ID: <20221014163426.tjxmek6xq6ojejea@sequoia>
References: <20221013183414.667316-1-ndesaulniers@google.com>
 <130adb69-ff37-51fd-26a2-674ab78ff044@gmail.com>
 <Y0kK2g+CUxbqPJ8d@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kK2g+CUxbqPJ8d@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-14 09:08:10, Greg Kroah-Hartman wrote:
> On Fri, Oct 14, 2022 at 09:24:11AM +0700, Bagas Sanjaya wrote:
> > On 10/14/22 01:34, Nick Desaulniers wrote:
> > > 3.16 was EOL in 2020.
> > > 4.4 was EOL in 2022.
> > > 
> > > 5.10 is new in 2020.
> > > 5.15 is new in 2021.
> > > 
> > > We'll see if 6.1 becomes LTS in 2022.
> > > 
> > 
> > I think the table should be keep updated whenever new LTS is announced
> > and oldest LTS become EOL, to be on par with kernel.org homepage.
> 
> Yeah, I didn't even realize this was in the kernel tree, I've just been
> keeping kernel.org up to date.

How about simply replacing this table with a pointer to
https://www.kernel.org/category/releases.html so that you don't have to
remember to update tables in two different places? It also has the
benefit that the documentation is never stale (missing new LTS
releases), even when someone is reading the documentation from an older
kernel release.

Tyler

> 
> thanks,
> 
> greg k-h
