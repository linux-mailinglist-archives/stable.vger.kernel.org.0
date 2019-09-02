Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B4A5B6A
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfIBQau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 12:30:50 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:39265 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfIBQau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 12:30:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 513FE61A;
        Mon,  2 Sep 2019 12:30:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 02 Sep 2019 12:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9ZLID+KoB4lWSTRpTPDQTN2S+oM
        /yyDEz1IKYcx+LU0=; b=On8qAiTCHxg24kPe5jZdp5HsObaVEGF8ak5kkoX7wsD
        vYZn9ruDkBAHdiWDIVziKjZBfFuu3In9bVn/uG/1/DyKwVS++7+lbgCgJqam0mFM
        /i3hZvIRMGKV5+0ZXJ7lkg3/g6J8AlFl+AUksTHbOiW1tiijNDqwGcsEkDhSMtM1
        7p5N8CoX50z/3+XCiCV2MUZF1euyClaeINBUS1cHsE+Vqb6XNL/bMLGd8+yGRp7E
        ITHwikRjahLqF8rtagqSwQXxdidfckhH1Toys2EsFQQbW8u+YE2OZxIhkWDp321U
        RmWUweWrNc7Lw5K6XFRd5EYNoUCzjMhE8Vje3OOnVDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9ZLID+
        KoB4lWSTRpTPDQTN2S+oM/yyDEz1IKYcx+LU0=; b=KMhhvvNAamZZjULxROrDWF
        sGBx3r6IBHXGn44+KMBc/S2rOlFz8+W1cKcHsJXa0aHL/EVwGRzdoZtHgueGg5uF
        LExaeOKSrTWgXhoKDfVqUKhM1mYEKcLEqIG7SdzmVTH74wKmAXI9aVs2cPZ7Vrlo
        86gU+v3QDdODBK+foJFFei4WmixfH5g3hC7fNBliYXeuJ9sDgQmBGyvMJewu5EYn
        k8kIej/fWipFMmOCYWY0C2Lky0VJ6IfHCay2nk3pRpJQjAiJLJ+NkLnoN5h7y2G2
        ucjyH3XtclFOe1/283HBxVAE3iHtwDiqgrdlfZFtU89s7JPT6yqjYow4B8Ze0oTw
        ==
X-ME-Sender: <xms:uENtXcUzMfDfQQjBsqCH26SYt7zTKAxC6hCe1U_8I1w2qos9gYyQUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejtddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:uENtXRoqdfp5yxbkYhGe_vC8Kf2pY4FigY8RINGXfMqoc9LbKB-SRg>
    <xmx:uENtXX5mcrXCKUlCxkH8H_dItkL3GrNTSLstatfjFv55K1xBi5ENcw>
    <xmx:uENtXZm14ODFKzdoAqrMoaZGpcVZC3RdGOBxFvuWEtjl-7K2R6fU_w>
    <xmx:uENtXeyugA_0LECbl1SeqrYLuNAm7-KrVFqnYbX4Fmw-YHvmJ1Rnxg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46FEAD60057;
        Mon,  2 Sep 2019 12:30:48 -0400 (EDT)
Date:   Mon, 2 Sep 2019 18:30:16 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190902163016.GA12364@kroah.com>
References: <20190827.174250.1230182945543056034.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827.174250.1230182945543056034.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 05:42:50PM -0700, David Miller wrote:
> 
> Please queue up the following bug fixes for v4.19 and v5.2 -stable
> respectively, thanks!


Now queued up, sorry for the delay.

greg k-h
