Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFABD4ECC95
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 20:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350739AbiC3Sq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 14:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350753AbiC3SqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 14:46:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0692A24D;
        Wed, 30 Mar 2022 11:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B5296121E;
        Wed, 30 Mar 2022 18:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867DEC340F2;
        Wed, 30 Mar 2022 18:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648665804;
        bh=sGa/KbapeH0kAxF/iIltso+wkaxybsSs7gubeGfT4pA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Bb1w9S3fLp8BI0e6yAIy5AeBtXyAZoYuE45kYBRzC8vE+FTxCij9oi73Ov+dxC04Q
         E8bXppOhAubQW66RvmTXDUGA1Gq1MeGQ7f/nFd9T9S5wk41ebnqNkMI6HXEYb2i8xb
         S9rigPlLQopxynjCR4uDpb0fSi+CBZbz8OWmlBJk4Hyeqjqc84JHZu6PywOfj9hTUs
         1XtvPwsVk5aE+i7qY1A2971slvcjqjIMqYJqBoPNQDnziMyiTSNaFW6ABeUTGB+dCa
         QCOEVNjHInaKqxoq6xUKTaKCXpilQKC9L6HyXOSggObHhRWTNZBtIHjlmIkjorTSUS
         kJAeaRw2/+nOQ==
Message-ID: <8b24038d-75a0-1124-642d-647ac8af0db3@kernel.org>
Date:   Wed, 30 Mar 2022 20:43:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Request for reverting the commit for Samsung HID driver
Content-Language: en-US
To:     junwan.cho@samsung.com,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?UTF-8?B?6rmA7J287Zi4?= <ih0923.kim@samsung.com>,
        =?UTF-8?B?67CV7LKc7Zi4?= <chun.ho.park@samsung.com>,
        =?UTF-8?B?67Cw7Jyk7Iud?= <yunsik.bae@samsung.com>,
        =?UTF-8?B?6rCV64yA7Z2s?= <daihee7.kang@samsung.com>,
        =?UTF-8?B?7J206rSR7Zi4?= <gaudium.lee@samsung.com>,
        =?UTF-8?B?66WY7LKc7Jqw?= <chunwoo.ryu@samsung.com>,
        =?UTF-8?B?64KY65GQ7IiY?= <doosu.na@samsung.com>,
        =?UTF-8?B?6rmA7IiY7ZiE?= <suhyun_.kim@samsung.com>
References: <YkQnvMpk9cRX8/F9@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com>
 <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
 <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
 <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
 <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
 <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
 <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
 <20220330092058epcms1p799e10561617c02a14d5d8b413722f678@epcms1p7>
 <20220330094354epcms1p282a35cfc39cea0b76125387a496d9284@epcms1p2>
 <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p3>
 <20220330095806epcms1p34fa55d36ed5ce200fb74a9a23aa279a5@epcms1p3>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220330095806epcms1p34fa55d36ed5ce200fb74a9a23aa279a5@epcms1p3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/03/2022 11:58, 조준완 wrote:
> You are the first person to point this out while exchanging emails.
> I don't know how to send in your favorite style in our mail system.
> This is the last email, so don't be annoyed.

Greg is not the first person pointing this out. We all did. :)
Top-posting makes reading and responding much more difficult. It's
inefficient. Proper quoting is the basis of efficient email
communication and well known between tech folks in internet.

Best regards,
Krzysztof

