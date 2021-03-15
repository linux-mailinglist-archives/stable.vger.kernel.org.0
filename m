Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD36333B25B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhCOMRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:17:11 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44883 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230133AbhCOMRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 08:17:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5FF95DEE;
        Mon, 15 Mar 2021 08:17:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 08:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=Q
        TNpZcM/XtZMSX4D6R8d3S9df2Cz3a//gcurkONM0Qs=; b=JkhfbjnbbRzhMy7VL
        HYBiuZOmUg5uqhKGatAyULgQv2RfM1alUTsBE5GTdmPguBkmDacFk31rino4VtLt
        MYIGNCl3Kv1xzB+N6mf4k1Mzik0P8cmE5TMmwz1UEncDSZWbCin0HZGud+3+wuW+
        +VRgmV5vZKeUXnTUfE0WpKnHh1XxbO6dZTKSjT9uQNmzSmSx7nNGAdkk97CN8naa
        edTc28c+knEY8OCU+ISr/MVdHmKScwmRhOYQlCRUz9Bb3t0We/O6duMAuDl6zIre
        MdPmfuk/NdgJ9b/FYW/OX0ETHulVMlu6je6n3at6kMLfULob1aekJshj1tGELRtX
        0NOPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=QTNpZcM/XtZMSX4D6R8d3S9df2Cz3a//gcurkONM0
        Qs=; b=PCrhFW9hVg6KawI0VIyrr8aqn9ePQMFjKZPLeiVE6kIlUlkD0U2iLZaz8
        okXwbeCAcHK/BfpmFnX3x/5JNEzTgG+hbVicemXYMcduBdTG5sJBiduIlCzH09Aa
        ueLwKYmAkjIgJXkYr5X3YUWT05g6WR/juGHIsbVi2TBgwY0CIhoPQqh6bYSqJ2c5
        sKcFDj/obP+ykCB/WvSoCIfkThLhHh5WE/Uki7X/V2M1S+XEhpy2iOZLiOxTg+A2
        52+5hwrL3n3JZ5hAeADgqVXskeQU9vO9H4XQXOX+KYWFnhLx/r1QOq+ku1xvzg6+
        zldGTSI97Ptu7Odmev5xpMSw7IgZw==
X-ME-Sender: <xms:QlBPYEmR0OwzJ9YDyt7EuYvoqdSbAphhZn8zJKT57w31sIYHKCwiYA>
    <xme:QlBPYD2Ol7wiAJF8WaYUL1TLAHk0lXQduQXNi941lXCovBeM_bK0LTs8AFR_PRTaK
    kca7r9C1AXm2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjsehtke
    ertddttddunecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeevtdeileeuteeggefgueefhfevgfdttefgtefgtddvge
    ejheeiuddvtdekffehffenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:QlBPYCq27nMZIa0nSRRRi5WjBoeqAUmiXMG4UQGx1YJyhfA2-bvWZg>
    <xmx:QlBPYAm46HOUMo4wo6CnxPga_K799bS9wfFCZARIByNc9oK7cPocoA>
    <xmx:QlBPYC02_iFakcwwWIb6coDtJaMseQk6yKT2b5Sf0MLzVT-SnjC9qw>
    <xmx:Q1BPYLhrdlKmq3KequV0LYo2-oHRWVqQkMIU60V6Hrso_kMxzvaL6g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95D301080057;
        Mon, 15 Mar 2021 08:17:06 -0400 (EDT)
Date:   Mon, 15 Mar 2021 13:16:51 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backported patches for stable 5.10
Message-ID: <YE9QM2IfNFrnE9Qv@kroah.com>
References: <aed51a72-7dbd-7d0c-df2c-4b226f63e44a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aed51a72-7dbd-7d0c-df2c-4b226f63e44a@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 09:18:28AM +0100, Jürgen Groß wrote:
> I've attached backports of 2 patches for 5.10.

All backported patches now queued up, thanks for doing them!

greg k-h
