Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F3768F6A0
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBHSKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBHSKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:10:20 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF608684;
        Wed,  8 Feb 2023 10:10:16 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 5FFF05C0266;
        Wed,  8 Feb 2023 13:10:14 -0500 (EST)
Received: from imap52 ([10.202.2.102])
  by compute5.internal (MEProxy); Wed, 08 Feb 2023 13:10:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675879814; x=1675966214; bh=RdyT2aNzAF
        XAKDt0rGVa6YaTEOddHbi0dBeD3wl6RD8=; b=tMpYURthWBhVNNPqgHWCDdEwd8
        I38LPdMNAOd1n5mgS0j+NfiJmZgGt08ydEeUsNUNJiv2DW3vfyJUHjs9pNqrOXdC
        GVCzM1opjs1ubH0Om2gbjXZzIfWJytJx2xU92CteVPoAPwDDMk2/E16m9MttIktx
        LAUQ992il4CDmtjgjyJ19OP2P3QnYCDwn9hmmWBHL12FP5RIflPdNXO8QYH5835g
        omtnMqSerQo5YF6OmS5OsJY9Z/fFdlSWfTyQubLEa/Sa91/Z2YG8WvIPpWwTQosX
        23Z5DLlDcw9yFNhFJmPvEjVCOhL9Cetz2Ingo93Nz62+MLJlBal4O6Pgxtrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1675879814; x=1675966214; bh=RdyT2aNzAFXAKDt0rGVa6YaTEOdd
        Hbi0dBeD3wl6RD8=; b=TjdtnmaJY3McDd9sQ3ntdW/IkKg63SJN0C8j7TWf00My
        0mjsHY8vM+Raz8VIw3nDF4SYECe8a9MAcTKDbQevuEFDGjGK8xrawJG/O4JOnV7i
        AZsjLGEFaqdzoN1yGfblpu5qReSxkmh6Vrx7anjnUFrXvirGw+jKdoyquFR3pab0
        dEo9YQ82aCWD5bWHmr1wgsbgxY+gCGKfUwoOZxg8/s4x4ZW4XbzfnMaTGBOceTD1
        0m+lwnGhJdfbtl61Avet+HXQi1h8EGWD0gBfqDCX1WTn+HLJP+oiRRnRYn4yXlwD
        vUKCjhWvyaymZ5f/I8n+bF71409oXMWwcJrriKjWVQ==
X-ME-Sender: <xms:heXjY-19N6mfkXjdhE22JjAbf85zBfwyxP44WCrHlpXfzoTyVyWnig>
    <xme:heXjYxGoNcz2jfAxeb1KC28-ZvRcIl3nK0gxUUEkdQ9RvP7kFFPmMIDxfBi0QdMjr
    KcF6OWsR1l4Ukx4Q98>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehuddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfofgr
    rhhkucfrvggrrhhsohhnfdcuoehmphgvrghrshhonhdqlhgvnhhovhhosehsqhhuvggssg
    drtggrqeenucggtffrrghtthgvrhhnpeeiueefjeeiveetuddvkeetfeeltdevffevudeh
    ffefjedufedvieejgedugeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehmphgvrghrshhonhdqlhgvnhhovhhosehsqhhuvggssgdrtggr
X-ME-Proxy: <xmx:heXjY24t5Mx8UJ4_YQTMwsKvqi-7wjzrrcvo7zI9btFrJYSu-wR3RQ>
    <xmx:heXjY_2XQ8gM4mSUJlXBmknPuz1iDNoNLhvJ6S7GpvFlSKnVJ3P1rQ>
    <xmx:heXjYxHJ1L5Br636NgomNrzygngFgqMxSU_eWvXIQi06GBDHer2ukA>
    <xmx:huXjY2SHjx1qI-vpmOmKcXM4MQXnP7NOyN6wjpcAoot4XKsLEvm5Tg>
Feedback-ID: ibe194615:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7BF25C60091; Wed,  8 Feb 2023 13:10:13 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-156-g081acc5ed5-fm-20230206.001-g081acc5e
Mime-Version: 1.0
Message-Id: <0fdac85f-c530-48a1-a506-cdb77ef012cb@app.fastmail.com>
In-Reply-To: <Y+PVau/cczvkllxr@kroah.com>
References: <mpearson-lenovo@squebb.ca>
 <20230208165018.1088701-1-mpearson-lenovo@squebb.ca>
 <Y+PVau/cczvkllxr@kroah.com>
Date:   Wed, 08 Feb 2023 13:09:53 -0500
From:   "Mark Pearson" <mpearson-lenovo@squebb.ca>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org,
        =?UTF-8?Q?Miroslav_Za=C5=A5ko?= <mzatko@mirexoft.com>,
        "Dennis Wassenberg" <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > Changes in v2: Put entry in correct position in quirks list.
> 
> Still in the incorrect place :(
> 
I'm an idiot - I sent the wrong file. Really sorry. Gah.
Third time lucky coming up..

Mark

