Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87D5832AB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiG0TC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 15:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiG0TCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 15:02:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0FB389C;
        Wed, 27 Jul 2022 11:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1658945952;
        bh=JCDCK9yrw3I1gJGNfUmVRzLTQwGLcyOig7ZAmiVFQGY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=h+xi5NDw6BeRX97636tfWxlOuXdY1ciIgcgI+CIvMbuH1Ik345FCqoZXvQ76eWDZq
         TnWGKk54JZqaJsYTKSamMPcInfU3Xp681A+S2VcyDpH1L4c8H1YX1VB5i67yO/8chw
         ZDu7IEB7rk9cClLuji0Nnp+hSwA5Qiz1As++7Reg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.120]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N7iCg-1nM6b41GqY-014gZe; Wed, 27
 Jul 2022 20:19:12 +0200
Message-ID: <ac440113-6054-a5b4-7a09-76b35fb910ab@gmx.de>
Date:   Wed, 27 Jul 2022 20:19:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:9j7VYiNGc1TSNXY/NRnL8mhlDGBGua5EM/whEq25ov0NbaFryK3
 mz2s8VUePXiRgew+MNuMCkB+b+dDrTaEGORP8k1fSaR1nj2zV+oMSSA8H0awMxSGZ8rljMf
 SHQHtHz2wPEPFScr+iJrnoZF9xnJoAT+LKqoqCam3iYh24alMIEdJuV5FMJdgaQ3hH81nfy
 9aSA+bm3Onv/qGy1hcq1Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8DhFGsCZepQ=:IDr8A6vs3cZbTqJVsZtryc
 tmqf4UV9UPZCIX6iK7ELPfR7hIkxym7L3ZBbt3FSSXotBuxn3NnTLF11H+hp5S4Ui+d/pHAnV
 PlaICDc5JXyab7ge05nYsmBPXKIqB+KS4+ePHmJ+ktrGPLzVzaLZtfLsm+ivYFNTyo4aILgkZ
 v+rypnAjDZRqs3zYauixQY8EAh1k/wwkQZGmMjTF2Of1o/vu3w851UF8SDusNslxnRyUS9xZb
 C6CotH01FkdjR/QgWrmIoGa1/uWgWNE/dBXNFC+btDMO25+ty6bi1CUiTfn92/5A+0SBfIT9Y
 lq1eatr7oTkuE6WHGDOx6xG3w717uwc3Jfzh0d4ziU7pPXnz6uWXhZ8GT7AQ29mGO3OHnJmft
 RSMETkfZkbwRYDqexw3qKPRoaLkzuNLEXaV4x+kT33W79ga/XYH3aPxvm9rMxUto5DlP4erqN
 yeuZHHiETMW2lavtmVq0vyaMpaA0WrVM3yrJG23lQQk9RJfmsVeTDjIiJ29tfHeJRwbOGBfx8
 N3Q6tq5w5LyKWwaHr8tyzjcrT+y9AmU5Qknoqyu6+KFXqdDfueAOYl3WUSUzQX/+V7RbbxwtY
 3aYXBkS+T0l5Sj1AnXO3pnANS9Ssju/ttf2C3ZOUsUQLHq9CqPfDy42AdNhGV5GWInQaDrry3
 iPTJGq7BH8Q/6kep525Bddb/7cz8bZCN1qkE68+uOI+sbJgsibTAR4S6kzePbjg42HoxMSqNA
 hIZ1s2cUWaecKSbqw51LwiPD+29TGQBkzt2fvw60XLqCvEgXGEfc4CYXTnp2mMM6Tr23Z1xYN
 /KCnes5tS/5eNKwUz5QIg6VY0j4CPCm1L2PAecM6S4BdGSje95rJ4Z3oJrjl8NoFW8lPDHvCX
 CJMfofz1GktZnYvnMN5pOeyo0XxIZ/WiiZs9xufilnxWddj07MyLgEhO4zUf+9qaSZsvyNoyz
 sNyHGHdvCJxIFm+x9NMFWOpzyC7nNw1BGLkKY8xAGehFsFqBwAqsi2JVGTjB7E/mkhCe6kcBj
 FiIA7/UzZo79wVhg/TolHA2IcFENFxoU80vo118VSFadCxf51K0iHeMXb/99XRAu+KbwTZD1X
 +LZOQTmQdc3DVHdi0F7lOo4wJhMy5MRVw7lv4o4xknUuxBPFie5SExEiA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.15-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
