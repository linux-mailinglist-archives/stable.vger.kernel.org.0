Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43601201F70
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 03:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgFTBSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 21:18:33 -0400
Received: from mail.itouring.de ([188.40.134.68]:43714 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgFTBSd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 21:18:33 -0400
Received: from tux.applied-asynchrony.com (p5ddd79e0.dip0.t-ipconnect.de [93.221.121.224])
        by mail.itouring.de (Postfix) with ESMTPSA id 0B1DD416013A;
        Sat, 20 Jun 2020 03:18:31 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 6C5C1F01605;
        Sat, 20 Jun 2020 03:18:30 +0200 (CEST)
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20200619141710.350494719@linuxfoundation.org>
 <1b6c9c26-04af-eb91-ef06-23d09bd31d91@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <1797f3d4-d3b6-00ac-30fc-a10f584acae9@applied-asynchrony.com>
Date:   Sat, 20 Jun 2020 03:18:30 +0200
MIME-Version: 1.0
In-Reply-To: <1b6c9c26-04af-eb91-ef06-23d09bd31d91@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-19 21:31, Holger Hoffstätte wrote:
> On 2020-06-19 16:28, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.7.5 release.
>> There are 376 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> Applied to 5.7.4 and running fine on two different systems (server, desktop)
> without problems.

Uh-oh: I have to take the above back. This release no longer suspends to RAM;
display and NIC shut down (box is no longer remotely accessible) but the power
stays on and I have to power-cycle.
Will try to revert a bunch of things tomorrow..

-h
