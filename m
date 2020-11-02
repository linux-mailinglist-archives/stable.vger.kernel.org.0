Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77EB2A24DD
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 07:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgKBGnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 01:43:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:53872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgKBGnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 01:43:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604299416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WxHvw/qqtDjoiNy/C2kravrZcDnBIwsJShFWvIEzYSc=;
        b=i7Avx5k9NY+LxZdpcnL2UPkAxVZ5dry/fJwd8vGtdO75/8PYpSbgMPN2hlnTEQK1rPUZdf
        sx6eUUNt9uvqf6Pf1Gc0ehwh6zaQtBirP1YASUssYT8TX9ZSADd2xBKxTBFPBSB38D1yYH
        22/xqO56zn0UFHxq4M+OB2itn4ZCt4Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2B9A2AC2E;
        Mon,  2 Nov 2020 06:43:36 +0000 (UTC)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Subject: Please add XSA fixes to stable branches 5.8 and 5.9
Message-ID: <3c023ab7-5daf-da7b-4b3b-66c0c2e6a97c@suse.com>
Date:   Mon, 2 Nov 2020 07:43:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

even while tagged with "Cc: stable@vger.kernel.org" you didn't take
some upstream patches from 5.10-rc1 for the recent 5.8 and 5.9 stable
branches:

073d0552ead5bfc7a3a9c01de590e924f11b5dd2
4d3fe31bd993ef504350989786858aefdb877daa
f01337197419b7e8a492e83089552b77d3b5fb90
54c9de89895e0a36047fcc4ae754ea5b8655fb9d
01263a1fabe30b4d542f34c7e2364a22587ddaf2
23025393dbeb3b8b3b60ebfa724cdae384992e27
86991b6e7ea6c613b7692f65106076943449b6b7
c8d647a326f06a39a8e5f0f1af946eacfa1835f8
c2711441bc961b37bba0615dd7135857d189035f
c44b849cee8c3ac587da3b0980e01f77500d158c
7beb290caa2adb0a399e735a1e175db9aae0523a
e99502f76271d6bc4e374fe368c50c67a1fd3070
5f7f77400ab5b357b5fdb7122c3442239672186c

Could you please add them? They are fixing some security issues. I have
tested them to apply cleanly.

For the older stable branches I'll supply backports.


Juergen
