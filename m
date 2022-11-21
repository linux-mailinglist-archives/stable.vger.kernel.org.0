Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2C86321EB
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiKUM1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKUM1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:27:42 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00859B1D0;
        Mon, 21 Nov 2022 04:27:38 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2EBE5580362;
        Mon, 21 Nov 2022 07:27:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 21 Nov 2022 07:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669033654; x=1669040854; bh=pzZVroo9kC
        ULUynpvnhsv4sPpCFIbmKL5clPSiXkhnA=; b=UXbdLjpHs6z9sbZPniHn6npcxr
        Fam/LfQQG8m1Ay3aVdCr2i1azAJpE+ErW+nQsuxLcPoL4LX77droh89JGM+3lY3Z
        5ftiCvLdASY5939dT5WQ7/9ZPAjGGTuNNg+8xUhwwiSIHphl/I9vsdnz46BLvXE8
        AQF5vHpeVBIqCcPvy+C3KZh5jocJ5LFeZ2WLC2zjOHAkqBOwlP4Xk1HsXkEgRq5T
        l369T5MF32e76BFu+B1itbctUY4g1jp+MencST2TJ3mOQuEGIt50Yh61hA/eHpGl
        Km9E6TySLEqpZ9SB2Tr1d5y652gjSLJ/guHMbVjpBygyk/yYC4DivmacQ4Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669033654; x=1669040854; bh=pzZVroo9kCULUynpvnhsv4sPpCFI
        bmKL5clPSiXkhnA=; b=Z6PxC3s5tt+JSv2lKV810BUcfvpnxil/bxpsGLpFxNzO
        rtxd3pR//q5o/QpNK7k5pQHDlIN8cwfmF5NPC52wtz7U62If7bJ81pSbcxPOUvGt
        yCuNAMzjW74MSE3rfCCobzCdRuOa56LdGbMOp/o+BvmPKuf+zethA48x/6hVfp5A
        VellZZciPoOwrIJCGIXs6SzPEDhMgP5ovyyW6nnkE8GgvRDtUzVJLDYdTwfQZwTw
        MgIR2F/PUeK/5/NOXcxtEtHl54cWSLRPj0C2CBqAfChOR3qgfdBvspC0hGHthBVO
        l+q1vnheKdfHy2GkFdyVpZ4nAzEP67wjYev9uPLShg==
X-ME-Sender: <xms:tW57Y7TKAKegDJ1UYbWF2fBRZizCIGfqkEhlxQBhkKwAMbK3Jf1E1Q>
    <xme:tW57Y8wiWg_CKwKK6MWVGKBdHghIIRfXHBXstJPzDJ2GHmgJuKe4HZzbuGFfOpPQz
    ZKdDlY380FEdA>
X-ME-Received: <xmr:tW57Yw1xFHhmuZWcaP1qJts5qhMfz9UchbKNWCweAEx3xaDysaUDLOf8DG4A67avNzKVkLWrUEuXL4-u0INasefraDIytWMl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:tW57Y7A8JUGboemCFo57NP2R02Nw2IKx08deL-cCRdLly20h6XH-wQ>
    <xmx:tW57Y0i75P_UUoflh1-8C_FJDBuYnP-ydVV7D6w4PvHOouhzAsWx9w>
    <xmx:tW57Y_oJ7Qvx0h2gD4_Q6qYBZb48KXK13Sr0KEfPIwyUJusQPLNRbw>
    <xmx:tm57Y_gCrxcjkVghOLGR0hZpWWmQYjqDXb5NCCROV9ghAUIFQ6ZHCA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Nov 2022 07:27:33 -0500 (EST)
Date:   Mon, 21 Nov 2022 13:26:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     stable@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, pbonzini@redhat.com, peterz@infradead.org,
        jpoimboe@kernel.org, cascardo@canonical.com, surajjs@amazon.com,
        ssouhlal@freebsd.org
Subject: Re: [PATCH 4.19 00/34] Intel RETBleed mitigations for 4.19.
Message-ID: <Y3tub/ldt7gwLczO@kroah.com>
References: <20221117091952.1940850-1-suleiman@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 06:19:18PM +0900, Suleiman Souhlal wrote:
> This series backports the mitigations for RETBleed for Intel CPUs to
> the 4.19 kernel.
> 
> It's based on the 5.4 [1] and 4.14 [2] backports.
> 
> Tested on Skylake Chromebook.

Very nice, thank you!

All now queued up.

greg k-h
