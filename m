Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC0ACC18
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfIHKkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 06:40:41 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35839 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbfIHKkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 06:40:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 567B021EC3;
        Sun,  8 Sep 2019 06:40:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 08 Sep 2019 06:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=sciQ7Jx6zGBEWCDYWRWEsxx4OSj
        YhdhHhMqXisBRhAk=; b=BDoKQSuGpfi9Q7rk4xcpsmVOBANx7QUQrVTuU4gXY1W
        i/nxZ6HfNEwDYfEmTUbo5D9NVgHZ2uwEtEB4bJc+mG0UffBJF6BVv2bB1O4A0CTR
        Ct6JKn3qKDiXpcMDY40lMjS4CBTlU7FtEuHNTTq1nTDjAs/RnWDPN5c0uIbM79bk
        h7avrutZcAXeuBiY+RcCGhwtFVas8IWcay9MqMiyDQrGFhHBhSEjZhilzlsJvXEY
        4eSg8E0tXydg8fr0E8qKQQr06Q2w16mdTSP+O9T1ct+vlJ02Z83m80+BhGUqRYX0
        OC0OytaqpyfivcyKpDvL6itDOheksd02LNSVH5788xg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sciQ7J
        x6zGBEWCDYWRWEsxx4OSjYhdhHhMqXisBRhAk=; b=YrbAYsN1eOTg+MQ8EPv9x9
        EwqC6NLRabBnwxcfiFuDWE/OLUi5Y64cK+I/T2Llqn7TrJwBj+aldh8kVAtEV6ig
        1oQpTwUQr85mU6PpduqoLDFp5YZ3S3nasCUjklsj+M5cDIpLmix4ZdGyJzZCk7AA
        UBC6x1nnKh4Dvv8/jBLJs7Yg3Nm+cdcgfuxkR9TZDwcrDrAzSzACScKheHhucOzf
        edZGfz5N7xVt238I2eWo0MIQhU7c8Cm145t9iEtWsC2+P+Tgf7bauDjlR4F/qEoA
        Mjbte/2Rpk2EvnA5CJKtVKCIoIRTblxyikYJ/L2cFCgQDGIHTNO2vFR1QJMsAO/A
        ==
X-ME-Sender: <xms:qNp0Xe36DXlB7D2cifC-TQ9uoijrlKU2XkAmKEzvKSzbrgP4a5DH4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeektddrvdehuddrudeivd
    drudeigeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qNp0XRzRKNhXj128EBpwU7H7B2ge-VBACG2gDpxz6-C7zcI_2PzDmA>
    <xmx:qNp0XR-YB_LKHStRcaSDEVk84aKc8fUPxkO8-IECdcfSJm3eCeZ2aQ>
    <xmx:qNp0Xf1wTGE_lNbA8BHVwTAlkqy-ERuts6ibUNY40pcwV22_A9YUPg>
    <xmx:qNp0XfbsjO2fFwVV_zmPakcKHRlexTtptojQmIAO6PReSG-vULPx1w>
Received: from localhost (unknown [80.251.162.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A5FDD6005B;
        Sun,  8 Sep 2019 06:40:39 -0400 (EDT)
Date:   Sun, 8 Sep 2019 11:40:21 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190908104021.GA22754@kroah.com>
References: <20190905.002347.1016661388177691903.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905.002347.1016661388177691903.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 12:23:47AM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.2
> -stable, respectively.

All now queued up, thanks.

greg k-h
